# Developing FlexDash/Node-RED Widgets

!!! WARNING
    Developing widgets is at the bleeding edge of FlexDash development these doc
    pages are far from complete.

FlexDash widgets, when integrated into Node-RED, are composed of three main parts:

1. A **widget** is a piece of code found in a `.vue` file that implements the representation
   of a "widget" (rectangular card with some visualization) in the dashboard.
   The widget code runs in the browser within the FlexDash framework.
2. A **node** is a piece of code found in a `.js` file that implements the machinery supporting
   a widget in Node-RED.
   It receives Node-RED messages, potentially transforms them, and forwards them to the
   corresponding widget in the dashboard.
   It also can receive messages from the widget and output them as Node-RED message.
   This code runs in Node-RED, specifically in Node.js on the "server".
3. A **node config** is a piece of code and html found in a `.html` file that implements the
   editing and configuration of the node in the Node-RED flow editor (also called admin).
   It provides the property sheets letting the user configure widget props, etc.
   This code is served by Node-RED and runs in the browser when editing flows.
  
Note: in normal Node-RED terminology both the `.js` and `.html` are called "the node". They're
distinguished here to make it clear what runs where.

## Options for writing custom widgets

FlexDash and its integration into Node-RED supports the development of custom widgets at
several levels of flexibility.

The simplest way to get started is to use the **custom widget node**.
This node is akin to the ui_template node in the std Node-RED dashboard.
It has an editor panel where a FlexDash widget's source file (".vue") can be created and
dynamically deployed to the dashboard.

Currently each custom widget node is a singleton: there is no way to reuse the same widget
multiple times other than copying the source code. Hopefully this can be improved in the future.

The next option is to create an NPM package containing a widget and the corresponding Node-RED
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
