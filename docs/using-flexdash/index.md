# Using FlexDash with Node-RED

FlexDash is a web dashboard with a deep integration into Node-RED.
A dashboard in this context is a web page that displays rectangular UI elements
to present dynamic real-time information.
Each UI element is called a widget and looks like a card, the cards are arranged in a grid,
and the web page can have multiple tabs each with its own grids and widgets.

The dashboard is primarily intended to display information but it can also accept input,
such as buttons to cause actions, switches, sliders, etc.
It is also possible to let the user upload or download files or change settings in a table.

The dashboard and the widgets provided by default are not a general web-page framework,
in particular, multi-step flows, linking between diverse parts of the site, or arbitrary
page layout are not directly supported.
It is possible to write custom widgets and even entire tab contents, so it is possible to
push the envelope quite far, but at some point it becomes more effective to write a custom site
and not be bound by the dashboard's framework.

## Features

- multiple dashboards
- modern, highly responsive UI
- mobile and desktop browser support
- display "old" Node-RED dashboard tabs in FlexDash tabs
- deep integration into Node-RED similar to "old" Node-RED dashboard
- uses Vue, which is one of the most popular and easy to learn web frameworks, making
  customization as easy as possible
- comes with a large set of widgets to display data and to let users initiate actions

## Limitations

FlexDash and its integration into Node-RED has many limitations :-).
Some stem from limitations in Node-RED,
some from the fact that not everything has been implemented yet, and
some stem from architectural limitations.

### Multi-user support

The dashboard is not multi-user because Node-RED is not multi-user.

That being said, "multi-user" means different things to different people.
In Node-RED there is one set of flows, and one set of values traversing nodes and links.
If two users look at the set of nodes and the data traversing these nodes they look
at exactly the same information.
The same is tru for FlexDash. A dashboard can't magically turn Node-RED into
some sort of multi-tenant engine.

There are some ways, however, where two users can look at the same Node-RED data and
see different things.
For example, zooming or panning graphs can be done independently and it is also possible
to display different data to different browsers by sending messages by connection ID.

Given better support for authentication is would also be possible to further segment
the data such that some users can see certain tabs or grids while others can't, or some
users may be able to perform actions while others may only be able to view the data.

### Authentication

FlexDash supports simple username/password authentication however the initial release of
the Node-RED integration does not.
Simple support is planned but not yet implemented.

More sophisticated authentication and authorization schemes, such as using OAUTH, could be
implemented in the future as well.

### Theming and other customizations

FlexDash comes with a light theme and a dark theme as well as a set of "material design" colors.
The uPlot charts come with an additional set of "maximally distinguishable" colors.
In the initial release, these colors are not customizable.
One reason is that the customization should leverage the Vuetify theming support,
which is changing for Vuetify 3 and is neither fully implemented nor documented.

FlexDash also contains a number of hard-coded values, such as the size of the widget grid
and various widget margins/padding, font sizes, icon sizes, etc.
Many of these values are inter-dependent and initially the added complexity to make them
customizable deters from getting the basics working.
There are two ways all this can be customized: provide hooks to change the values and
implement a custom grid.

