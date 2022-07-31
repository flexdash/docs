FlexDash is an IoT dashboard built using modern web components and with deep integration into Node-RED. It is very similar in general concept to the standard Node-RED dashboard: it has tabs filled with a grid of widgets, each of which displays data fed through some node in a Node-RED flow. E.g.:

![image|587x500](upload://nMxpLb0GWHPCcNzDcDcXmaAI5bW.png)

is driven by the following flow, where the ochre nodes correspond to widgets in the dashboard:

![image|690x243](upload://hsTq8uKYdisSd75zZSN19PbxIFX.png)

Some of the other features of FlexDash are:
- it supports multiple dashboards
- any property of any widget can be changed dynamically, e.g. title, colors, size, data, etc.
- it supports dynamic arrays of widgets, i.e., the number and contents of widgets is controlled dynamically using Node-RED messages
- it supports Node-RED subflows, i.e., a panel with widgets can be placed into a subflow and each instance of that subflow produces a copy of that panel and widgets (with some limitations...)
- it is optimized for both desktop and mobile browser support
- it can embed tabs of the std Node-RED dashboard seamlessly enabling tab-by-tab migration
- it uses Vue 3, which is one of the most popular and easy to learn web frameworks, making customization as easy as possible
- it has deep integration into Node-RED very similar to the std dashboard
- it uses the same chart library as Grafana (called uPlot), which is a very flexible and super fast charting library
- it comes with a decent set of widgets to display data and to let users initiate actions (buttons, toggles, etc.)
- it supports developing custom widgets with hot-module-reload of the widget
- it's all open source, no strings attached

About the making of FlexDash... I've been wanting something more modern, responsive, and much better performing than the std Node-RED dashboard for years. About a year and a half ago I had a month of "forced computer time without work" :laughing: due to surgery and decided to see what happens if I put something together.

The first version of FlexDash did not have any real integration into Node-RED but it worked. It is now in active use in a project for field-deployed Raspberry Pis that detect and record radio-tagged birds as they migrate around the globe. Along the way the feedback I gathered from the Node-RED community is that a Node-RED dashboard must come with a set of NR nodes that represent the widgets of the dashboard while at the time FlexDash used a more powerful but evidently less intuitive paradigm. I eventually decided to try my hand at writing a Node-RED integration that makes FlexDash work pretty much like the std NR dashboard. Little did I know... I'm pretty sure I've now spent more time on that integration than on FlexDash itself... But here it is in alpha form.

This first alpha release comes with many caveats. The first two are:
- it probably won't work for you :upside_down_face:
- it has more unknown issues than known ones, and there's a long list of known ones :crazy_face:

But more seriously, the core functionality of FlexDash itself has been quite stable so far but the integration into Node-RED makes me nervous because it makes pretty deep assumptions about how NR works. And "NR" really refers to two distinct software packages: the Node-RED server and the dashboard, each of which is many multiples the size of all of FlexDash.

This is perhaps a good place to mention that FlexDash has [documentation](https://flexdash.github.io/docs)! It's of course alpha-ware but it has a list of limitations and known issues, information on how to get started, and how to load the example flows that show off all the existing widgets. The widgets themselves all have the standard Node-RED type of help info (shown in the side-bar of the NR flow editor) and all properties that can be set on widgets have short help text in the edit forms in the flow editor.

I'm currently in the midst of migrating my own home-automation dashboard to FlexDash. I have a couple of tabs converted and the rest are simply embedded from the std dashboard. I fully expect to trip up and hit bugs and missing features, but I thought I might as well release earlier rather than later to gather feedback.

tl;dr; [Get started!](https://flexdash.github.io/docs/quick-start/)

To end with some eye candy, here are three tabs of my own home automation dashboard. The first is a "native" FlexDash tab, the second an embedded Node-RED tab, the third an embedded Grafana tab.

