# Customizing Time Plots
========================

!!! NOTE
    This section is very incomplete.

Display of values in TimePlotRaw
--------------------------------

Values displayed in time plots, such as in scales, legends, and tooltips can be customized by
passing functions to uPlot's `axes`, `series`, and `tooltips` options.
Since the FlexDash config is in json, these functions must be passed as strings,
and TimePlotRaw essentially `evals` these strings to get the functions.

For reference, the code in TimePlotRaw that does the
[string-to-function conversion](https://github.com/flexdash/flexdash/blob/main/src/widgets/time-plot-raw.vue#L159-L166)
is:
```
        // if we got a value formatting function we need to 'eval' it
        if (typeof serie.value === 'string') {
          serie.value = new Function('u', 'v', `"use strict";return (${serie.value})`)
          // handle point fill for dark mode
          if (this.is_dark) {
            if (!serie.points) serie.points = {}
            if (!serie.points.fill) serie.points.fill = '#1e1e1e'
          }
        }
```
where `u` is a handle onto uPlot, and `v` is the value.
There's similar code a few lines down for `axes[i].values` and again for `scales[i].range`.

To format temperature in degrees centigrade, for example, the series definition should have
something like:
```
"series": [
    {},
    {
        "value": "v.toFixed(1)+'°C'""
    }
]
```

and then for the Y axis something like:
```
    "axes": [
        {},
        {
            "scale": "temp",
            "values": "vv.map(v=>v&&(v.toFixed(1)+'°C'))",
            "grid": {
                "show": true
            }
        }
    ],
```
Here `vv` is the array of values used in the scale, and it's possible for values to be null
(e.g., for tick marks that don't have a value shown).
