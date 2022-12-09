# Extensions to Vue components

FlexDash uses the Vue "options API" for widgets, which means that each widget is written as
a Javascript object.
FlexDash extends the set of object fields to encode properties of widgets.
It also extends the fields that can be specified for `props` to add help information.
For example, here's a Vue component fragment that has FlexDash-specific fields:

```javascript
export default {
  name: 'Stat',  // Vue field
  help:          // FlexDash field, skipped by Vue, text shown in FD UI and Node-RED UI
        `Display colored numeric or text status value.
The Stat widget displays a colored centered numerical or text value. Optionally a unit string
can be appended and is rendered as a superscript.
`,

  props: {
    unit: { type: String, default: "",            // Vue fields
            tip: "superscript after the value" }, // FlexDash field
...
```

## Component fields

- help
- output
- output_value

## Prop fields

- tip
- types (FlexDash performs type conversion)
- prop names (e.g. _color)

