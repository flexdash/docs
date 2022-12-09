# Create an NPM package from an existing widget

!!! WARNING
    The steps below have not been tested and the node-red-fd-start repo doesn't exist yet...
    
!!! NOTE
    This section is for users that want to create an NPM package with a custom widget.

This section walks through the steps to modify an existing widget.
If you are familiar with Vue this may be all you need to start writing your own widgets
(but check out the section on FlexDash extensions to Vue components).
If you are not familiar with Vue, follow along even if you don't understand the details so you
can immediately try out what is described in subsequent sections.

The example used here is to create a `my-gauge` widget from the `gauge` widget without any
material change other than the name.

### 1. Clone node-red-fd-start

The node-red-fd-start repo contains the minimal scaffolding for a set of widgets.

```
git clone @flexdash/node-red-fd-start node-red-fd-mywidget
```

!!! TIP
    You must use the `node-red-fd-` prefix or your widget won't be loaded into FlexDash.

If you don't want a git repo you can also download a zip (click on the green "code" button and choose "download ZIP").

### 2. Copy the gauge widget

Copy the `.vue` file of the gauge widget.
The widgets built into FlexDash can be found at https://github.com/flexdash/flexdash/tree/main/src/widgets,
select `gauge.vue`.
Click on the "raw" button in the bar at the top of the source code, copy all, paste into your
favorite editor into `./widgets/my-gauge.vue` (below the node-red-fd-start directory).

### 3. Change the names

In `my-gauge.vue` around line 43 change the name of the widget from `name: 'Gauge'` to
`name: 'MyGauge'`. (Use the CapitalCase spelling: this results in an HTML element `<my-gauge>`.)

In `package.json` change `my-widget` to `my-gauge`.

### 4. Generate the Node-RED node

For this step you need the generator script `gen-widget-nodes.js` in the node-red-flexdash repo.
Run it with your current working directory being `node-red-fd-mywidget`.
If you have a "regular" install of Node-RED you should be able to run it with something like:
```
node /.../.node-red/node_modules/bin/gen-widget-nodes.js
```
If you are using docker, the easiest is to git clone the node-red-flexdash repo and use it from there,
e.g.:
```
cd ..
git clone https://github.com/flexdash/node-red-flexdash.git
cd mywidget
node ../node-red-flexdash/gen-widget-nodes.js
```

You should now have `my-gauge.js` and `my-gauge.html`, which form the Node-RED code for
your widget.

### 5. Install your widget in Node-RED

```
cd /.../.node-red
npm i /.../node-red-fd-mywidget
```

### 6. Restart Node-RED

Restart Node-RED, reload any open browser windows with the Node-RED flow editor, then locate
the `my-gauge` node in the palette within the long list of FlexDash nodes.
