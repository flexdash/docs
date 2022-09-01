# Developing FlexDash/Node-RED Widgets

Planned outline (sorry):

- the three parts of a FlexDash widget: the widget (.vue file), the node (.js file), the config (.html file)
- very brief primer on a .vue file: template, component, styles
- very brief primer on a Vue component: props, data, computed, ... , links to Vue tutorials
- FlexDash extensions to Vue components: help, tips, output, ...
- connecting a node with its widget
- WidgetAPI: communicating with the widget
- working with props: maintaining JSON data structures, using arrays, ...
- configuring the widget
- automatically generating the node and/or the configuration

When talking about FlexDash widgets and nodes it is important to understand that there are
three distinct parts to a widget and its integration into Node-RED:

1. The **widget** is a piece of code found in a `.vue` file that implements the representation
   of the widget in the dashboard.
   This code runs in the browser within the FlexDash framework.
2. The **node** is a piece of code found is a `.js` file that implements the machinery supporting
   the widget in Node-RED.
   It receives Node-RED messages, potentially transforms them, and forwards them to the
   corresponding widget in the dashboard.
   It also can receive messages from the widget and outputs them as Node-RED message.
   This code runs in Node-RED, specifically in Node.js on "the server".
3. The **node config** is a piece of code and html found in a `.html` file that implements the
   editing and configuration of the node in the Node-RED flow editor (also called admin).
   It provides the property sheets letting the user configure widget props, etc.
   This code is served by Node-RED and runs in the browser when editing flows.
  
Note: in normal Node-RED terminology both the `.js` and `.html` are called "the node". They're
distinguished here to make it clear what runs where.

## Options for writing custom widgets

FlexDash and its integration into Node-RED supports the development of custom widgets at
several levels of flexibility.

In the future, the simplest way to get started will be to use the _not yet implemented_
**custom widget node**. This node is akin to the ui_template node in the std Node-RED dashboard.
It will have an editor panel where a FlexDash widget's source file can be created and dynamically
pushed to the dashboard.

The next level is to create an NPM package containing a widget and the corresponding Node-RED
node.
One of the benefits over the custom widget node is to be able to publish the result
as NPM package allowing other Node-RED users to install it.
Another benefit is that the widget can import dependencies, e.g. NPM packages that
it needs to produce a visualization.

Creating the NPM package is very similar to writing a custom Node-RED node except that
the node part can be auto-generated.
It is recommended to start by writing the widget, a `.vue` file, and then running a
generator that produces the corresponding node `.js` and node config `.html` files.
All the nodes in `node-red-fd-corewidgets` have been produced this way.

Once the generator has been run everything can be tested using the "flexdash dev server"
built into `node-red-flexdash`.
The dev server automatically pushes edits of the `.vue` file to FlexDash as soon as the file
is modified and it enables all the in-browser Vue debugging tools.

When the widget is ready for "production use" a build step generates the files necessary to load the
widget into FlexDash without the dev server.
This also enables the widget and its associated node to be distributed via NPM to other Node-RED users.

The auto-generated code more or less forwards incoming messages straight to the widget's props.
For some complex widgets it may be necessary to write a custom node instead of using the
code generator.
This can be done relatively easily by starting from the generated code and modifying it.
The generated code is relatively simple and primarily calls helper functions in
`node-red-flexdash`.
Depending on what is desired, the custom node code can choose to call the same helper functions or not.
The dev server and build step options remain the same.

## Vue primer

FlexDash uses the very popular Vue 3 web framework.
Beyond its popularity, which ensures that there are many tutorials and examples out there,
the benefit of Vue is that it has a relatively soft learning curve and that it provides
some structure for the UI code.

Vue uses "enhanced" web components. A web component is a piece of code that gets
instantiated on a web page using an HTML tag. E.g., just like `<h1>...</h1>` produces
a heading on the page writing `<my-widget>...</my-widget>` can produce an instance of
a Vue component.

To write a Vue component up to three parts are necessary:
1. An HTML template: this is a fragment of HTML that replaces `<my-widget>...</my-widget>`
   or put differently, this is the HTML that renders the component.
2. A piece of javascript code: this is what implements the dynamic functions of the
   component.
3. A CSS style sheet that provides styling for the component's HTML.

One nice aspect of Vue is that is allows these three parts to be combined into a single file
(this is called Single File Components, or SFC, in Vue) and the file extension is `.vue`.

(Note that technically of the three parts above only the javascript code is required but in
practice the vast majority of FlexDash widgets have an HTML template and many have some CSS.)

In addition to using Vue 3 FlexDash also uses the Vuetify 3 toolkit.
Vuetify is essentially a web component library that provides an implementation of many
typical UI components such as buttons, data tables, menus, forms, test fields, icons, etc.

### A very simple widget

A FlexDash widget is a Vue component that follows some additional conventions and that is
flagged to FlexDash as being a widget.

There are many excellent Vue tutorials (see ...), the intent of the example in this section is
to complement these by showing a complete FlexDash widget example that uses some of the
conventions used by FlexDash and that explains how all the pieces, including the Node-RED ones,
hang together.
The example used is a `simple-button` widget displays a button with a custom label and that
outputs a value when clicked.

For the sake of formatting the HTML, CSS Javascript portions of the `.vue` file are shown
below separately. They are simply concatenated one after another in the actual `.vue` file.

The HTML of a widget is inserted into a "card" by FlexDash, so the widget only needs to
display the content of that card.

```html
<template>
  <v-btn variant="elevated" class="ma-auto" @click="clicked()">
    <span class="label">{{ label }}</span>
  </v-btn>
</template>
```

The template here consists of a single HTML tag: v-btn, which is a button component provided
by Vuetify ( all Vuetify components start with "v-").
The elevated variant has a drop shadow giving the button an elevated look and "ma-auto" is
a Vuetify helper class that adds a `margin: auto` CSS tag to the component, which causes it to
be vertically and horizontally centered in its HTML container, which is the above-mentioned card.

Within the button comes the text the button displays, which is the content of a (yet to be defined)
variable called label.
The `{{`..`}}` notation is used to insert the output of a Javascript fragment, which here is
just the content of a variable.

The `@click` is a Vue notation that causes the code on the right of the = to be executed when the
component emits an event called 'click'.
In this example a (yet to be defined) method 'clicked' is called.

The Javascript for the simple-button widget is:

```javascript
<script scoped>
export default {
  name: 'SimpleButton', // the name of the widget
  // help text shown in the Node-RED info pane of the node
  help: `Button to send a message
Pressing the button sends a message with a specified payload.
The button may contain a label that is shown centered in the widget.`,

  // props are the inputs to the widget, they can all be set from Node-RED
  props: {
    label: { default: "clickme", tip: "" },
    output: { default: "I was clicked" },
  },

  output: true, // signals to FlexDash that the widget can output a message

  // simple methods within the component
  methods: {
    clicked() { // handle the clicking of the button, i.e., the handler for the '@click'
      this.$emit('send', this.output)
    }
  }
}
</script>
```

The CSS for the simple button widget is:

```css
<style scoped>
  .label { color: red; }
</style>
```

The resulting widget looks as follows in FlexDash:

In order to work with Node-RED the node `.js` and `.html` files can be auto-generated.
While these are relatively short only the fragments that tie everything together are shown
here.

The `.html` file displays the editing panels for the widget in the Node-RED flow editor:


The `.js` file implements the node running in the Node-RED run-time:

   

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


## Requirements

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
- Any other npm package must be decalred as dependency in a `package.json` in the `widgets` directory
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

