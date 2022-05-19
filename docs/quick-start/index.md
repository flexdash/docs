# FlexDash w/Node-RED: Quick Start

To quickly try something out it is recommended to use docker.
While docker can be confusing at the beginning, the [docker](docker.md) quick-start page
attempts to provide enough examples and explanations to perform simple tasks without much
prior knowledge.
The big benefit of using docker is that it's easy to throw away tests and to start new tests
from a clean sheet, i.e., known-good configuration.

Alternatively, you can also easily install FlexDash on a regular Node-RED installation.

## Parts

FlexDash consists of a number of parts:

- [FlexDash](https://github.com/tve/flexdash) is a single-page web application that runs
  in the browser and displays the dashboard.
- [Node-RED-FlexDash](https://github.com/flexdash/node-red-flexdash) is a Node-RED
  module that contains the main integration into Node-RED. It is the server part with
  which the FlexDash dashboard communicates.
- [Node-RED-FD-CoreWidgets](https://github.com/flexdash/node-red-fd-corewidgets) is a
  Node-RED module that contains Node-RED nodes for all the widgets that are built into
  FlexDash.

## Installing FlexDash in Node-RED

For a non-docker set-up, install FlexDash using `npm install @flexdash/node-red-fd-corewidgets`,
this will automatically pull-in the other necessary parts as dependencies.
You can also use the "manage palette" feature in the Node-RED editor (in the top-right menu)
to install "@flexdash/node-red-fd-corewidgets", however, a restart of Node-RED is required
after the installation!

!!! WARNING
    If FlexDash (`@flexdash/node-red-fd-corewidgets`) is installed using the Node-RED editor's
    "manage palette" feature then a restart of Node-RED is required for FlexDash to actually
    function. This is due to [bug #569](https://github.com/node-red/node-red/issues/569) in Node-RED.

The core widgets module comes with a set of example flows, which you can install using the
Node-RED editor's "import" feature.
