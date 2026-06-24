# Rigor And Style Standard

## Data Checks

Before plotting, inspect and report:

- Missing values in plotted variables and grouping variables.
- Non-numeric values in numeric columns.
- Negative values where biologically impossible or incompatible with the transform.
- Duplicate sample IDs or duplicated feature IDs when uniqueness is required.
- Group order, group labels, and sample-to-group mapping.
- Sample size per group and whether it supports the requested error bars or test.
- Units and transformations, including log bases and pseudocounts.
- Outliers that may dominate axis limits or conclusions.
- Pairing/blocking variables when paired designs are possible.
- Batch, cohort, or donor variables when they could confound the conclusion.

If a check affects interpretation and cannot be resolved from data or user instruction, ask before drawing the final figure.

## Statistics

- State the exact test/model, sidedness if relevant, correction method, and error-bar definition.
- Do not compute a P value if the design is unclear.
- Use adjusted P values when the user's result table provides them and the claim is from multiple testing.
- Format displayed values with uppercase italic P. Use scientific notation for every displayed P value unless the user explicitly provides a stricter journal format.
- Never display unexplained stars alone; if stars are requested, define them in the caption or report, not as in-figure prose.

## Style Constants

- Font size: 6 pt for all text.
- Axis and tick stroke: 0.5 pt, approximately 0.176 mm in vector output.
- Tick length: 1.1 mm.
- Grid lines: off.
- Panel background: white or transparent; no decorative gradients.
- Plot title: absent unless needed; if present, one short title only.
- Legend text: concise labels only.
- Same chart type: identical physical size, plot margins, text sizes, stroke widths, tick lengths, and annotation positions.

## Palette Rule

Use an approved project palette when provided. If no approved palette is available, ask for it before final output.

For explicitly provisional drafts only, the fallback palette is:

```text
neutral grey #D4D4D4
blue         #298ACA
green        #5A9E6F
red          #B84A4A
gold         #C49A3A
purple       #7A6FB0
black        #000000
white        #FFFFFF
```

Do not expand this palette without user approval.

## Export

Preferred order:

1. PDF for manuscript vector review.
2. SVG for editable vector workflows.
3. TIFF at 600 dpi or higher for raster submission when requested.
4. PNG only for quick previews.

When resizing a figure, change only the physical canvas and layout coordinates. Keep font size, axis stroke, tick length, point stroke, and legend text size constant.

## Assembly

When assembling panels:

- Align panel edges and plot areas, not only outer images.
- Use equal page margins.
- Preserve each panel's original typography and axis dimensions.
- Keep panel labels short, consistent, and outside data regions.
- Export the assembled figure separately from individual panels.
