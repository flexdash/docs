# Imports in custom widgets

When writing custom widgets it is often useful to be able to import components and
libraries already found in FlexDash.
The difficulty in doing so is that FlexDash is already completely linked, minified,
and bundled.
This means that importing using source file paths does not generally work.
The work-around is that FlexDash places a number of widgets, components, libraries, and utilities
into the global `window` variable.
The result is that custom widgets can access these from the `window` variable.

The list of items in the `window` variable is printed in the browser console when
FlexDash loads, but in general it consists of:

- `window.Vue` - the [Vue library](https://vuejs.org/api)
  (ex: `const version = window.Vue.version`)
- `window.Vuetify` - the [Vuetify toolkit](https://next.vuetifyjs.com/en)
  (ex: `const VRangeSlider = window.Vuetify.VRangeSlider`)
- `window.uplot` - the [uPlot library](https://github.com/leeoniya/uPlot)
  (ex: `const uplot = window.uPlot.default`)
- `window.Palette.widgets[`<WidgetName>]` -
  [built-in widgets](https://github.com/flexdash/flexdash/tree/main/src/widgets)
  (ex: `const Gauge = window.Palette.widgets['Gauge']`)
- `window.Palette.components[`<ComponentName>]` -
  [built-in components](https://github.com/flexdash/flexdash/tree/main/src/components)
  (ex: `const SvgGauge = window.Palette.components['SvgGauge']`)
- `window.Utils[`<utilname>]` -
  [built-in utilities](https://github.com/flexdash/flexdash/tree/main/src/utils)
  (ex: `const color2hhex = window.Utils['colors'].color2hhex`),
  see list printed in the browser console at start-up

### Additional imports

When using the custom widget node the only additional imports possible are directly from URLs,
e.g. from CDNs, unpkg, or other distribution sites.

When writing an NPM package with widgets it is possible to import other NPM packages in the
standard manner, i.e. listing them in `packages.json` and `npm install`ing them.
See the related documentation pages.
