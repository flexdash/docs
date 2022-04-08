# Intro

The current documentation focuses on using FlexDash with Node-RED.
There is nothing Node-RED specific in FlexDash, it can be used with many other back-end
systems, however the Node-RED integration of FlexDash uses FlexDash in a special
constrained manner.

## Using FlexDash with Node-RED

Planned documentation outline

### FlexDash w/Node-RED Quick start:
- quickly set-up a FlexDash demo to try something out
- docker & non-docker versions

### Using FlexDash with Node-RED:
- what's a dashboard
- limitations: multi-user, authentication, theming
- dashboard config nodes, URLs, where to point the browser
- FD concepts: tabs, grids, iframes, panels, widgets, props, topic tree (advanced)
- tips and tricks about the stat and label widgets
- editing and laying out grids (incl tips & tricks)
- editing and laying out panels (incl tips & tricks)
- using iframes
- migrating from the old Node-RED dashboard to FlexDash (iframes, nodes)

### Cheat-sheet for developing FlexDash/Node-RED Widgets:
- introduction to the FlexDash-custom node
- extensions to the Vue component spec (help, tip, output, ...)
- HTML environment in which a widget template is rendered
- required function calls in nodes
- WidgetAPI summary

### Developing FlexDash/Node-RED widgets:
- the three parts of a FlexDash widget: the widget (.vue file), the node (.js file), the config (.html file)
- very brief primer on a .vue file: template, component, styles
- very brief primer on a Vue component: props, data, computed, ... , links to Vue tutorials
- FlexDash extensions to Vue components: help, tips, output, ...
- connecting a node with its widget
- WidgetAPI: communicating with the widget
- working with props: maintaining JSON data structures, using arrays, ...
- configuring the widget
- automatically generating the node and/or the configuration
