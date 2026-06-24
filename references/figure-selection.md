# Figure Selection

## Principle

Choose the chart after identifying the scientific claim, evidence hierarchy, and reviewer risk. The figure must serve the manuscript argument.

## Archetypes

### Quantitative Grid

Use when the claim rests on numerical comparison: group comparison, treatment effect, dose response, time course, performance, robustness, heatmap-like matrices.

Typical panels: bar plot, boxplot, violin plot, dot plot, line plot, scatter plot, forest plot, heatmap.

Layout: aligned axes, shared legends, consistent scales, compact spacing.

### Schematic-Led Composite

Use when a mechanism, workflow, experimental design, model architecture, device, or process must be understood before quantitative results.

Layout: schematic left or top, occupying about 35-60% of the figure. Quantitative validation sits beside or below it.

### Image Plate Plus Quantification

Use when representative images are primary evidence: microscopy, histology, fluorescence channels, spatial overlays, zoom crops, blot-like panels, masks.

Requirements: scale bars, channel labels, processing notes, source-data traceability, and nearby quantification.

### Asymmetric Mixed-Modality Figure

Use for Nature-style multi-panel figures combining evidence types. Use one hero panel and smaller supporting panels. Panel size follows evidence importance, not symmetry.

## Chart Choice By Data Question

Group comparison:
- Prefer dot plot with mean +/- SEM, boxplot, violin plot, or bar plot with raw points.
- Avoid bar plots without raw points for small sample sizes.
- Avoid 3D plots and overloaded colors.

Time-course or longitudinal trend:
- Use line plot with confidence interval, individual trajectories, or area plot for cumulative/compositional trends.
- Add intervention markers and time labels.
- Use consistent y-axis limits when panels invite comparison.

Dose-response or gradient response:
- Use line or scatter plot with fitted curve.
- Use log-scale x-axis when dose spans orders of magnitude.
- Add EC50/IC50 and confidence interval when relevant.

Correlation or association:
- Use scatter with regression, bubble plot for a third variable, or density scatter for overlap.
- Add Pearson or Spearman correlation, sample size, and statistically justified P value.

Distribution:
- Use histogram, density, boxplot, violin plot, or ridgeline plot when shape, outliers, or spread matter.

Matrix or omics pattern:
- Use heatmap, clustered heatmap, annotated heatmap, or bubble matrix.
- Add row/column annotations, color scale legend, normalization method, and clustering method if shown.

Embedding or single-cell structure:
- Use UMAP, t-SNE, PCA, composition bar plot, marker heatmap, pseudotime plot, volcano plot, or ligand-receptor bubble matrix.

Effect size or uncertainty:
- Use forest plot, point-range plot, confidence interval plot, or paired slope plot.

Imaging evidence:
- Use image plate, multi-channel grid, overlay, zoom crop, and image-derived quantification.

Network or interaction structure:
- Use network graph, adjacency matrix, bubble matrix, or bipartite interaction plot.

## Panel Ordering

Default order:

1. Establish system, sample, model, method, cohort, or experimental design.
2. Show primary effect or main comparison.
3. Show mechanism, localization, or explanatory evidence.
4. Quantify representative images or qualitative observations.
5. Add controls, robustness, subgroup analysis, or sensitivity analysis.

## Reviewer-Risk Check

Before finalizing, verify:

- Every panel answers a unique scientific question.
- The main conclusion is understandable without the full caption.
- Sample size, statistics, and error bars are defined.
- Axes are comparable across panels that invite comparison.
- Representative images are quantified.
- Source data are traceable.
- The same claim cannot be made more rigorously with fewer panels.
