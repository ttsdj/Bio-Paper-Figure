# Bio-Paper-Figure

Create rigorous, Nature-style biological research figures from manuscript conclusions, result files, variables, and statistical requirements.

This repository contains a Codex skill named `bio-paper-figure`.

## Contents

- `SKILL.md`: Main workflow and trigger instructions.
- `references/figure-selection.md`: Figure archetype and chart-selection rules.
- `references/rigor-and-style.md`: Data checks, statistics, style constants, palette, export, and assembly rules.
- `references/mechanism-prompt.md`: Mechanism-figure prompt prefix.
- `scripts/rna_target_barplot.R`: Reproducible R script for target-gene expression barplots.

## Use

Invoke the skill as `$bio-paper-figure` and provide:

- the core conclusion,
- data path or pasted data,
- group definitions,
- statistics or differential-result columns,
- required output formats,
- approved color palette when final output is required.

The skill asks for missing information when a choice could affect scientific rigor.
