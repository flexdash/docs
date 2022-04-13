# Docker

_Running Node-RED and FlexDash in Docker_

!!! TODO
    Write a docker intro

## Hello World

The following steps bring up a Node-RED instance with FlexDash installed.
You can then import one of the built-in examples to explore FlexDash.

Run the following command in your preferred shell (you can use the `\` or concatenate
everything into one long commandline):

```
docker run --rm -ti -p 1990:1880 \
  --entrypoint bash \
  --name my-node-red \
  nodered/node-red:2.2.2 \
  -c "npm i @flexdash/node-red-fd-corewidgets; npm start --cache /data/.npm -- -v -userDir /data"
```

Open http://localhost:1990/ and you will see the Node-RED editor. Use the top-right menu and
select "import", then "examples", then "@flexdash/node-red-fd-corewidget", and pick one of
the examples. Place it in the flow.

!!! TODO
    Need to hook up the grid to the dashbaord...

Deploy and open http://localhost:1990/flexdash and you will see the dashboard corresponding
to the example.

In the commandline window where you launched docker you will see the Node-RED log.

Once you are done, hit ctrl-C for the docker command and everything will vanish.

### Explanation

The commandline above launches a docker container that first installs FlexDash and then runs
Node-RED. In more detail, the command options do the following:

- `-rm` deletes the container after it stops
- `-ti` keeps the container running in the foreground so you can see the Node-RED log and
  you can hit Ctrl-C to terminate.
- `-p 1990:1880` maps the host's TCP port 1990 to the container's port 1880, which is the port on
  which Node-RED starts its web server. You can map 1880 to 1880 (`-p 1880:1880`), the example
  above uses a different port in order not to conflict with a regular Node-RED you may
  already have running. As you might guess, you can run multiple Node-RED containers
  simultaneously to try out different things as long as you choose a different port and a
  different container name for each one.
- `--entrypoint bash` runs a shell instead of directly launching Node-RED, which is what
  the Node-RED image does by default
- `-name my-node-red` gives the container a name which is helpful if you look at
  running containers (`docker ps`) or you want a shell in the container
  (`docker exec -ti my-node-red bash`)
- `nodered/node-red:2.2.2` is the image to download and run, pick a more recent version
  of Node-RED if there is one.
- `-c ...` is the command the shell is to execute, `npm i @flexdash/node-red-fd-corewidgets`
  installs the core widgets and brings node-red-flexdash in as a dependency, and
  `npm start ...` starts Node-RED

This method of launching Node-RED is great for quickly trying something out from a clean slate.
It takes a few seconds to start up and everything is gone at the end.

## Raspberry Pi

!!! TODO
    Test running this on rPi

## Keeping data and avoiding the reinstall

The above command launches a truly throw-away container: once it terminates there's
nothing left. For a more persistent set-up where you can relaunch the container yet
keep your flows and other data, such as file-based context stores, you need to provide
a "data" directory to store all this independently of whether a container is running or
not. Conveniently, the FlexDash modules can be installed in the data directory so they are
persisted too and don't need to be reinstalled every time the container is launched.

### Background on Node-RED directories

Before laying out a solution it's worth understanding what can go where and how, because
once that's understood the action plan becomes trivial and it becomes easy to tweak things
slightly for different purposes.

Node-RED primarily uses two directories: its home directory (or working directory) and
its data directory. When running under docker these are `/usr/src/node-red` and `/data`, respectively.
Node-RED itself is installed in the home dir, which may be read-only,
and it places all user data in `/data`, which is assumed to be writable.

Node.js, the programming framework used by Node-RED, expects code to be installed in a
`node_modules` subdirectory. For example, Node-RED is actually found within
`/usr/src/node-red/node_modules`. Because Node-RED assumes that its home dir may be read-only
and it needs to be able to install additional packages it uses _two_ `node_modules`
directories: the one in its home directory and also `/data/node_modules`.

Finally, to install a package, change directory to the one _above_ `node_modules` and
run `npm install <package>`.

### The solution

We want our data to persist, so we mount a host directory onto `/data`, this way when something gets
written there it really is in that host directory.
We also want the packages we install to persist, so we install them into `/data/node_modules`.
We then want to repeatedly launch the Node-RED container using the persisted data and persisted
module installation.

To achieve this two different container runs will be necessary. The first one will install
the desired packages and subsequent runs will just run Node-RED.
For the first run, create a data directory to store the persistent data,
for example `./node-red-data`. Then launch a container as follows:

```
docker run --rm -ti \
  -v $PWD/node-red-data:/data \
  --entrypoint bash \
  nodered/node-red:2.2.2 \
  -c "cd /data; npm i @flexdash/node-red-fd-corewidgets"
```

The only new options compared to the incantation at the top of this page is the -v:

- `-v $PWD/node-red-data:/data` mounts the node-red-data subdirectory onto `/data` within
  the container, i.e., any access to files under `/data` in the container will be rerouted
  to `node-red-data` on the host. The paths must be absolute, so under unix `$PWD` will expand
  to the current working directory. You can also just type out `/home/me/somedir/node-red-data` or
  under Windows `C:\Users\me\node-red-data` (the part after the colon remains `/data` since that's
  the path inside the container).

This container will run for a few seconds and then exit. You will see the NPM install progress
and also spit out some warnings, in particular "saveError ENOENT: no such file or directory,
open '/data/package.json'". These warnings are due to the fact that we're installing into an
empty directory, which is a bit of an odd usage.

What this accomplishes is to install the chosen packages (here node-red-fd-corewidgets and its dependencies) using the version of npm installed in the container, which is the one Node-RED
will also use.

Now comes the second step, which is to actually launch Node-RED:

```
docker run --rm -ti -p 1990:1880 \
  -v $PWD/node-red-data:/data \
  --name flexdash-demo \
  nodered/node-red:2.2.2
```

This second incantation is quite simple: it just mounts the persisted data directory onto
`/data` and starts Node-RED the standard way (plus gives the container a name so a
`docker ls` shows something recognizable).

- To stop the container, hit Ctrl-C. It can be restarted anytime in the same manner.
- To install additional packages, stop the Node-RED container, run the first incatation with
  a modified npm commandline, then start the Node-RED container again.
- To try a different version of Node-RED, just alter the `2.2.2` part and as long as the
  versions are compatible, it should work.
- To start from scratch, delete the `node-red-data` directory and start over.

### Installing packages using the palette-manager

Node-RED includes the ability to install packages from its web interface,
specifically using the palette manager found in the top-right menu.
The install tab allows to search for packages and a small install button installs
them in the `data` directory just like the `npm install` command used above.

In principle, this means that the first docker run above could be skipped, going straight to the
second one, and then simply using the palette manager to install `node-red-fd-corewidgets`.

Unfortunately, as of version 2.2.2 there is a bug, which is that the nodes found in
dependencies are not installed. What this means is that if one installs
`node-red-fd-corewidgets` then `node-red-flexdash` and `node-red-flexdash-plugins`
are also installed, but the configuration nodes these two packages contain are not loaded
resulting in a non-functional situation.

There are two work-arounds:
1. Explicitly install the dependencies: search for flexdash in the install tab and install
   all three packages listed above.
2. Install just the corewidgets package, then stop the container and restart it: Node-RED
   will then pick-up the config nodes from the dependencies.

### Using source directories

There is one more tweak that is helpful when developing a new package, e.g. some new FlexDash widgets.
In that case one needs Node-RED to use the package being developed from its source directory
on the host.
The assumed directory layout here is a `node-red-data` subdirectory for `/data` and a
`node-red-fd-mywidgets` subdirectory with the new nodes and widgets.

The first incantation to install the source package is very similar to the one above.
The two twists are to map the source directory into the container (previously the packages
came from the internet) and to perform a "link install", which creates a symbolic link in
`node_modules` to the source directory (within the container, can't link to something outside).

```
docker run --rm -ti \
  -v $PWD/node-red-data:/data \
  -v $PWD/node-red-fd-mywidgets:/data/node-red-fd-mywidgets \
  --entrypoint bash \
  nodered/node-red:2.2.2 \
  -c "cd /data; npm i ./node-red-fd-mywidgets"
```

On the host, looking at `node-red-data/node_modules` should show a symbolic link
`node-red-fd-mywidgets` -> `../node-red-fd-mywidgets`. (If the `packages.json` has a
`name` entry with a namespace then it will be a bit different. I named my
package `@tve/node-red-fd-mywidgets` and thus ended up with
`node-red-data/node_modules/@tve/node-red-fd-mywidgets` -> `../../node-red-fd-mywidgets`).

!!! NOTE
    The `package.json` in `node-red-fd-mywidgets` needs to have its dependencies right,
    specifically, it needs to depend on `node-red-flexdash` so the latter gets installed
    automatically!

After this set-up (which could map multiple source package directories, btw) the Node-RED launch
is a matter of mounting the appropriate source directories (and the data dir):

```
docker run --rm -ti -p 1990:1880 \
  -v $PWD/node-red-data:/data \
  -v $PWD/node-red-fd-mywidgets:/data/node-red-fd-mywidgets \
  --name flexdash-demo \
  nodered/node-red:2.2.2
```

!!! NOTE
    When Node-RED is launched there is no npm install happening. Everything works assuming
    no dependencies have changed because of the symbolic link. If the dependencies in the
    source package's `package.json` are altered, then a re-run of the first incatation with
    `npm i` is required.

## Summary

In the end, what the docker containers provide are:
- a pre-packaged self-contained installation of Node-RED
- an isolated filesystem namespace (directory tree) so arbitrary files on the host cannot be affected
- a controlled way to map host directories into the container's namespace

all the docker incantations described on this page basically map host directories into the
container filesystem tree, run some `npm install` to install desired packages, and
then run Node-RED.
Hopefully the explanations allow you to customize and tweak docker to suit your needs!

## FAQ

### I tried to combine the npm install in /data with launching Node-RED and it didn't work

The command tried is:

```
docker run --rm -ti -p 1990:1880 \
  -v C:\temp\fd_nr_data:/data \
  -v C:\Users\Me\node-red-fd-test:/data/node-red-fd-test \
  --entrypoint bash \
  --name my-node-red \
  nodered/node-red:2.2.2 \
  -c "cd /data; npm i ./node-red-fd-test; npm start --cache /data/.npm -- -v -userDir /data"
```

Which produced this output:

```
[...]

+ ./node-red-fd-test@0.1.0
added 105 packages from 129 contributors and audited 105 packages in 9.408s

[...]

npm ERR! enoent ENOENT: no such file or directory, open '/data/package.json'

```

#### Answer

You can see that the npm install worked 'cause npm prints "updated 1 package".

However, the `-c` commandline first performs `cd /data`, then `npm install`, and then tries to start
Node-RED using an npm command. The latter looks up what "start" means in `package.json`, which isn't
there in `/data`, and that produces an error.

The `package.json` to start node-red is in `/usr/src/node-red` so one has to `npm start` there
(it's the "working directory" of the container, so the bash shell starts there, that's why it works
if there is no cd command).

It is suggested to keep the install and the running separated in two container invocations.
To join them one has to cd back before the npm start.

