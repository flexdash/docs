# Background and Implementation Details

## Background on linking in dev mode vs. production

Developing widgets using the dev server vs. running the same widgets in "production" uses quite
different linking steps and this can lead to rather confusing errors and problems.
The linking steps in Javascript involve a number of tools, plugins to those tools and everything
is both complicated and magic.
When the magic fails one is left with a heap of complexity leading to frustration...

Linking external packages with custom widgets is fundamentally different in dev mode from
production mode. In dev mode everything is served up by Vite ("dev server"). It serves up one
source tree, which is the FlexDash source tree and the external packages are essentially
npm installed into that source tree (using symlinks). This means that when some module in
the external package has an import statement the path is resolved by Vite the same way it resolves
it for all of FlexDash.

In production mode, FlexDash is built and bundled, and then at run-time loaded into the browser.
External packages with custom widgets are similarly built and bundled _in isolation_.
They cannot simply import modules that are a part of FlexDash like in dev mode.
They also cannot declare Vue, Vuetify as their own dependencies because that would result in
multiple copies of these libraries loaded in the browser.
The solution used is for FlexDash to export selected functions of Vue, Vuetify, and uPlot
in the `window` global variable and to use `vite-plugin-externals` to transparently import
references to Vue, Vuetify, and uplot.

#### Specifics for imports in dev mode

- `import ... from "Vue"`, `import from "Vuetify"`, `import from "uplot"`: ???
- use of `<v-some-component>` is handled by the Vite vue-loader plugin and the source code is
  transformed to an import of `vuetify/lib/components/VSomeComponent/index.mjs`

#### Specifics for imports in production mode

- `import ... from "Vue"`, `import from "Vuetify"`, `import from "uplot"` are transformed
  by the `vue-plugin-externals` Vite plugin to reference `window.Xxxx` instead of performing
  an actual import. These globals are set in FlexDash's `main.js`.
- use of `<v-some-component>` magically works because all Vuetify components are registered
  with Vue in FlexDash's `main.js`, so they don't need to be explicitly imported.

Note that the explicit import of all Vuetify components is not just necessary for the registration
but also to ensure they all actually show up in the bundle since FlexDash itself doesn't use all.
It would make sense to exclude some very large components in the future to reduce code bloat.

## Reference

### Common (dev&prod) requirements

#### Widget files and names

- The custom widgets must be in an NPM module whose name starts with `node-red-fd-`.
- Each widget must be in a `.vue` file located in a `widgets` subdirectory in the module directory.
- The widget should have a compound name (i.e. with a `-`) to avoid clashes with HTML tags.
- The widget's file name should (must?) be the widget's name (plus the `.vue` extension).
- The widget must declare its name using the CamelCase version (i.e. `name: "WidgetName" field).

#### Node-RED nodes

- Node-RED nodes can be generated from the widget '.vue' file using the `gen-widget-nodes.js`
  script in `node-red-flexdash`. The `.js` and `.html` files can also be written manually.
- The correspondence between a node and a widget is established by the `initWidget` call in the
  node's constructor,
  e.g. `const widget = RED.plugins.get('flexdash').initWidget(this, config, 'WidgetName')`.
- Multiple nodes can instantiate widgets of the same type, however, a node cannot instantiate
  multiple widgets (except for arrays), because the widget uses the node's ID and multiple
  calls to `initWidget` would create an ID clash.

#### Dependencies

- The widget code can call Vue globals using an implicit global `Vue` variable.
- The widget can use any Vuetify component in its template without special declaration or import.
- The widget can call any Vuetify global using an implicit global `Vuetify` variable.
- The widget can use uPlot using a global `uplot`.
- Any other npm package must be declared as dependency in a `package.json` in the `widgets` directory
  and must be installed there using `npm install` resulting in a `./node_modules/<package>`.

#### Installation

- The module with the widgets must be installed using npm. This can either be an installation
  from the npm repository (e.g. `npm install node-red-fd-my-widgets`) or an installation from
  source (e.g. `npm install /home/myself/src/node-red-fd-my-widgets`).
- The module may be installed in the Node-RED `user_dir`'s node_modules directory
  (`/usr/src/node-red/node_modules` when using docker, `~/.node-red/node_modules` otherwise)
  or in the `data_dir`'s node_modules
  (`/data/node_modules` with docker, `~/.node-red/???/node_modules` otherwise).
- node-red-flasdash ends up searching for widget vue files in:
  - `${user_dir}/node_modules/node-red-fd-*/widgets/*.vue`
  - `${user_dir}/node_modules/@*/node-red-fd-*/widgets/*.vue`
  - `${data_dir}/node_modules/node-red-fd-*/widgets/*.vue`
  - `${data_dir}/node_modules/@*/node-red-fd-*/widgets/*.vue`

### Requirements for development

There are no additional requirements for development other than having to run the "dev server"
using the `flexdash dev server` node in node-red-flexdash.

In dev mode (using the dev server) all Javascript pieces are served up by the dev server (Vite)
using modern ESM modules.
Vite does some pre-bundling and other optimizations to be able to serve everything up relatively
quickly.
All the cached modules can be found in `flexdash-src/node_modules/.vite`, i.e. in the
FlexDash source directory installed by the dev server or by yourself. There are scenarios where
an `rm -rf` of that directory helps...

When the dev server is started it prints some info messages to the Node-RED log about custom
widgets it has loaded. E.g.:

```
18 Aug 13:09:02 - [info] [flexdash dev server:FD] widgets: searching in /usr/src/node-red
18 Aug 13:09:02 - [info] [flexdash dev server:FD] widgets: searching in /data
18 Aug 13:09:02 - [info] [flexdash dev server:FD] widgets: found node-red-fd-testnodes
18 Aug 13:09:02 - [info] [flexdash dev server:FD] widgets: found node-red-fd-network-diagram
```

### Requirements for production

In production FlexDash is served up using an optimized and minified bundle.
External/custom widgets are imported "on the side" from their own bundle.
This loading is done by the palette loader, which obtains a handle onto the laoded widget
bundle and inspects it to determine what to add to FlexDash's palette.
The dashboard config sent to FlexDash contains the names of widgets and these names are looked
up in the palette, that's how FlexDash knows to display a custom widget.

Often widgets need to call code that exists in FlexDash, such as Vue, Vuetify, or uPlot
functions. These are accessed via global variables and the build must be configured to
exclude these libraries from the build of the widget module (see below).

- The `package.json` in the `widgets` directory should have a build script which
  invokes `vite build`. This allows the build step to be invoked using `npm run build`.
- The `widgets` directory must have a `vite.config.js` to configure the build step, it is best
  to adapt the config from the `node-red-fd-testnodes` repository. (Primarily, any 
  dependencies on other npm modules must be added.)
- The `widgets` directory must have an `index.js` file with a line that re-exports all widgets:
  `export default import.meta.globEager("./*.vue")`, see the `node-red-fd-testnodes` repo.
- The build must be performed before Node-RED is started, resulting in a `dist/fd-widgets.es.js`
  file below the `widgets` directory. Additionally, if the `.vue` files include `<style>` a
  `dist/style.css` file will be present.

When Node-RED starts and the node-red-flexdash dashboard node starts it prints some info messages
to the Node-RED log about extra widget modules it has found. E.g.:

```
18 Aug 13:09:05 - [info] [flexdash dashboard:FD] Looking for extra widgets in /usr/src/node-red,
 /data
18 Aug 13:09:05 - [info] [flexdash dashboard:FD] Extra widget modules: @flexdash/node-red-fd-tes
tnodes/widgets/dist/fd-widgets.es.js, @tve/node-red-fd-network-diagram/widgets/dist/fd-widgets.es.js
```

