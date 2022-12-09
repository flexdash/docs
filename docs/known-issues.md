# Known Issues

As of this writing, FlexDash is in alpha state.
The general functioning of the dashboard itself (i.e. the code running in the browser) is fairly
robust and has been used in several projects. However, the Node-RED integration and some of
the ramifications are not polished.
The main known issues are listed below.

!!! WARNING
    One of the reasons FlexDash and its integration into Node-RED have an 'alpha' status
    is that the way certain things work may change, forcing users to rebuild their dashbaords.

    For example, very early on the FlexDash node names were changed to have an "fd"
    prefix, e.g., "button" became "fd button". At that time no-one was using FlexDash so it was an
    easy decision.


## Big picture issues

Note: not all the changes described below will happen, this is more a list of what
is being contemplated.

- There are more unknown issues than known issues 😉
- FlexDash uses the Vuetify set of UI components and more specifically, the Vuetify 3
  beta version which still has a lot of quirks. (Edit: this is nearing resolution.)
  Some of the positioning of elements
  is messed-up, in particular overlays and pop-ups are problematic. Some desirable UI elements,
  such as data tables, tree view, date picker, etc have not yet been ported from version 2.
- Support for subflows has hard limitations, such as only supporting one level of subflows, and
  its implementation uses some dirty tricks due to limitations in Node-RED's flow editor.
- The Node-RED integration overall relies on a large set of assumptions about the (undocumented)
  inner workings of Node-RED and the flow editor. This is bound to result in corner cases that do
  not function well. Specific areas of concern are projects, disabled flows, and export/import of
  flows.
- Editing a FlexDash node in the flow editor uses `typed input` input fields which have various
  issues with ~~defaults for boolean values, `null` as object or string values~~, not supporting
  the input of multi-line strings, ~~not supporting a color picker~~, and more. An input field better
  suited for FlexDash is badly needed.
- There is no authentication for dashboard users in the Node-RED integration. FlexDash supports
  very basic auth but the integration doesn't. This is a to-do item.
- While it is possible to develop new FlexDash widgets with instant "hot module reload" of
  changes there is no support for quick dynamic widgets equivalent to the "UI template"
  node in the "old" Node-RED dashboard. Support is planned (and was there with Vue 2) but
  needs to be reimplemented.
- FlexDash does not deal with the browser's history. E.g., the back button does not work as
  one would expect when switching between tabs and reloading the page switches to the initial
  tab.
- Some of the internals of FlexDash may yet change to allow arbitrary nesting of containers,
  e.g. panel in panel in grid in tab. This can be done without breaking existing dashboards
  but it may introduce some instability and some minor breaking changes.
- There has been discussion about switching from having dozens of core nodes to having a
  single generic "FlexDash Widget" node that has a "widget type" selector. In that case, the
  current nodes can be maintained for a while giving time to migrate, but eventually this will
  create some migration work for early adopters.


## Minor issues

A list of issues is kept in the
[README](https://github.com/flexdash/node-red-flexdash/blob/main/README.md)
of the node-red-flexdash repo.
