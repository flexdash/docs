# FlexDash w/Node-RED Quick Start

To quickly try something out it is recommended to use docker.
While docker can be confusing at the beginning, this quickstart attempts to provide enough
examples and explanations to perform simple tasks.

The big benefit of using docker is that it's easy to throw away tests and to start new tests
from a clean sheet, i.e., known-good configuration.



Alternatively, you can also easily install FlexDash on a regular Node-RED installation.

!!! note
    The Node-RED FlexDash nodes do not currently work under Windows (some paths
    have '/' instead of '\'). This will be fixed soon. However, it all works great
    using docker under Windows...

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

To install FlexDash either `npm install node-red-fd-corewidgets` or use the "manage palette"
feature in the Node-RED editor (in the top-right menu) to install "node-red-fd-corewidgets".

The core widgets module comes with a set of example flows, which you can install using the
Node-RED editor's "import" feature.
