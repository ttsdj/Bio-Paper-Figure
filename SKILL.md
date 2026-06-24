---
name: bio-paper-figure
description: Create rigorous, publication-ready biological research data figures from a user's core manuscript conclusion, result files, variables, and statistical requirements. Use when the user asks to draw, revise, standardize, batch-generate, export, or assemble Nature-style scientific figures for papers, especially bioinformatics plots, experimental quantification plots, omics figures, imaging quantification, or multi-panel biological evidence figures. Also use when the user provides a conclusion and asks Codex to choose an appropriate chart type, check data rigor, enforce unified figure formatting, export PDF/SVG/TIFF, or create a mechanism-style figure prompt.
---

# Bio Paper Figure

## Core Rule

Produce figures as manuscript evidence, not decoration. Require the user's core conclusion before choosing a chart type. If information needed for rigor is missing, ask a focused question and do not invent values.

For mechanism-only figures, read `references/mechanism-prompt.md`, use the exact Chinese prompt prefix there for image generation, then add the user's exact biological description.

## Required Inputs

Before drawing, confirm these items are present:

- Core conclusion or claim the figure must support.
- Data file path(s), sheet names when relevant, and output directory.
- Variables: outcome, grouping, sample IDs, time/dose/order, units, and labels to display.
- Statistical plan: test/model, multiple-testing correction, error-bar definition, paired/unpaired design, and whether extra statistics should be computed.
- Biological context: organism, assay, cohort/model, experimental groups, and any controls.
- Target output: single panel, batch figures, or assembled multi-panel figure; required formats among PDF, SVG, TIFF, PNG.
- Approved color palette. If no project palette is available, ask for one before final output; a provisional draft may use the fallback palette only if clearly labeled draft.

## Workflow

1. Parse the conclusion into the scientific claim, evidence hierarchy, and reviewer risks.
2. Inspect the data structure before plotting. Do not rely only on filenames or column names.
3. Choose the figure archetype and chart type from `references/figure-selection.md`.
4. Run the data rigor checks in `references/rigor-and-style.md`.
5. Generate reproducible plotting code in R/ggplot2 by default unless the user requests another backend.
6. Export editable vector output first: PDF and/or SVG. Export high-resolution TIFF when requested.
7. If multiple same-type panels are produced, keep identical physical size, font size, axis line width, tick length, margins, and internal annotation layout.
8. When separate figures are complete, assemble an aligned combined version with equal page margins and strict panel alignment.
9. Report exactly what was generated, which statistics were used, where outputs were saved, and any limitations or unresolved rigor issues.

## Non-Negotiable Style

Use these defaults unless the user provides stricter journal or project requirements:

- Font size: 6 pt for every text element, including titles, labels, axis text, annotations, and legends.
- Axis line and tick stroke: 0.5 pt.
- Tick length: 1.1 mm.
- Grid lines: never show.
- Titles: at most one short title per plot; no subtitle and no descriptive sentence inside the figure.
- Legends: one- or two-word labels only; no explanatory sentences.
- P values: use uppercase italic `P`; use scientific notation for very small values.
- Figure resizing: changing physical dimensions must not change font size, axis stroke, tick length, or other absolute style constants.
- Empty space: preserve effective information density; avoid large blank regions unless biologically meaningful.

Read `references/rigor-and-style.md` for exact checks, export settings, and fallback palette rules.

## Built-In Script

Use `scripts/rna_target_barplot.R` when the request matches batch target-gene expression barplots:

- Two-group or multi-group expression comparison.
- Bar height is mean `log2(expression + 1)`.
- Raw replicate points are shown.
- Error bars are SD, SEM, or none.
- Gene name appears in a fixed grey box.
- `P` value appears inside the plot.
- Every gene is exported as an independent PDF plus a report CSV.

Run the script self-test before relying on it in a new environment:

```powershell
Rscript C:\Users\23698\.codex\skills\bio-paper-figure\scripts\rna_target_barplot.R --self-test
```

For other chart types, write a task-specific script while preserving the same style constants and validation discipline.

## When To Ask Instead Of Drawing

Stop and ask if any missing item could change the scientific conclusion, chart type, statistics, or visual interpretation. Common blockers:

- The core conclusion is absent or vague.
- Data paths are missing or unreadable.
- Group definitions, sample pairing, units, or replicate identities are unclear.
- The statistical test is unspecified and cannot be inferred from the study design.
- The approved color set is absent for final output.
- The user requests a mechanism figure but provides insufficient biological mechanism details.

Ask the smallest number of questions needed to proceed rigorously.
