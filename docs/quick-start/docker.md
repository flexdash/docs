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
- `-p 1990:1880` maps the TCP port 1990 to the container's port 1880, which is the port on
  which Node-RED starts its web server. You can map 1880 to 1880 (`-p 1880:1880`), the example
  above uses a different port in order not to conflict with a regular Node-RED you may
  already have running. As you might guess, you can run multiple Node-RED containers
  simultaneously to try out different things as long as you choose a different port an a
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

## Raspberry Pi

!!! TODO
    Test running this on rPi

## Keeping data and avoiding the reinstall

The above command launches a truly throw-away container: once it terminates there's
nothing left. For a more persistent set-up where you can "relaunch" the container yet
keep your flows and other data, such as file-based context stores, you need to provide
a "data" directory to store all this independently of whether a container is running or
not. Conveniently, the FlexDash modules can be installed in the data directory so they are
persisted too and don't need to be reinstalled every time the container is launched.

Create a data directory to store the persistent data, e.g., "./node-red-data". Then launch
the container as follows:

```
docker run --rm -ti -p 1990:1880 \
  -v $PWD/node-red-data:/data \
  --name my-node-red \
  nodered/node-red:2.2.2"
```

The only new options compared to the previous incantation is the -v:

- `-v $PWD/node-red-data:/data` mounts the node-red-data subdirectory onto `/data` within
  the container, i.e., any access to files under `/data` in the container will be rerouted
  to `node-red-data`. The paths must be absolute, so under unix `$PWD` will expand to the
  current working directory. You can also just type out `/home/me/somedir/node-red-data` or
  under Windows `C:\Users\me\node-red-data`.

While the container is running and after it stops all the data will be in `node-red-data`.
If you create some flows the next time you start the container again they will still be there.
You can also start a slightly different version of Node-RED and assuming the versions are
compatible it will work just fine.

In order to use FlexDash, open the menu (top-right corner) and choose "manage palette", then
on the install tab, search for flexdash. Install `@flexdash/node-red-fd-corewidgets` and
`@flexdash/node-red-flexdash`. You should now see the FlexDash core widgets in the node palette.

Drag a `datetime` node into the flow and edit it. You will need to create a FlexDash container
(grid), in there a FlexDash tab, and finally a FlexDash dashboard. The default options are OK
for all of them. After you deploy, point a browser at http://localhost:1990/flexdash.
