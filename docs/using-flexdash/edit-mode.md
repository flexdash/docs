# Edit Mode

FlexDash supports adding, deleting, moving, and editing widgets live in the dashboard.
Some of that functionality is turned off by the Node-RED integration but some of it
is still available and necessary.

In the Node-RED flow editor the following editing actions can be performed:

- adding and removing widgets by adding and removing nodes in a flow
- moving widgets between panels, grids, and tabs by changing which config node
  they are associated with
- editing any of the properties of a widget using the flow editor's widget edit panel
- adding, removing, and editing panels, grids, and tabs

All the actions in the flow editor are performed using property sheets and are only reflected
in the dashboard after the Node-RED flow(s) is deployed.

It is not possible to perform the following actions in Node-RED:

- changing the position of a widget within its panel or grid
- changing the order of tabs

Performing these actions in Node-RED would require the development of a whole UI and it would
be very frustrating because the placement of widgets in the grid is non-trivial and thus changes
would have unintuitive effects.

In the FlexDash dashboard an edit mode can be turned on using the gear icon in the top-right corner.
The edit mode displays an edit pencil in the top-right of each widget that can be used to bring up
an edit panel for the specific widget (or grid or tab).
These edit panels operate live, meaning that any changes can be observed immediately in the
dashboard. However, to persist the changes it is necessary to go to the Node-RED flow editor and
deploy!

Using the dashboard's edit mode the following actions can be performed:

- editing any of the properties of widgets, panels, grids, and tabs
- reordering tabs
- reordering widgets within their grid

It is not possible to perform the following actions in the dashboard's edit mode:

- adding or removing widgets, grids, or tabs (corresponding Node-RED nodes would have to be
  created under the hood and placed into some flow)
- moving widgets between panels, grids or tabs

The split nature of editing widgets is still a work in progress.
Some ideas are to iframe a version of FlexDash into the Node-RED flow editor to perform live
actions, such as reordering widgets...
