# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Academic course materials for **Artificial Intelligence Foundations** (Universidad Anáhuac México), maintained by Dr. Aboud Barsekh-Onji. Covers 14 conference topics spanning search algorithms, evolutionary computation, fuzzy logic, swarm intelligence, neural networks, and NLP. All presentations are in Spanish.

## Identity
- Prof. Dr. Aboud Barsekh-Onji, Professor at the Faculty of Engineering, Universidad Anáhuac México
- Researche Topics:Evolutionary Computation, Many Objectives Optimization, Fuzzy Substractive Clustering, hybrid models (Fuzzy Logic, PSO/MOPSO, LSTM, Machine and Deep Leraning)

## Technical environment
- OS: Ubuntu 24.04, ThinkPad T14
- Python: conda env `research` (Python 3.11)
  - NEVER use venv/virtualenv, always conda
  - Interpreter: /home/aboudonji/miniforge3/envs/research/bin/python
- MATLAB: R2025b (main language)
- LaTeX: pdflatex by default, xelatex as fallback

## Delivery rules
- Academic documents: Markdown or LaTeX/Beamer (Berlin theme, 16:9)
- Presentations: Beamer, NOT PowerPoint
- Skills available in: ~/.config/claude/skills/

## Language
- Respond in the language in which the question is asked (ES/EN/AR)

## LaTeX Presentations

### Compilation
Each conference folder has its own `sample.tex` or `main.tex`. Compile with:
```bash
pdflatex sample.tex
pdflatex sample.tex   # run twice for TOC/cross-references
```
Or with latexmk:
```bash
latexmk -pdf sample.tex
latexmk -pdf -C      # clean auxiliary files
```

### Beamer Theme
All presentations use the **Berlin** theme with `aspectratio=169`. The custom theme files (`.sty`) are co-located in the same folder as the `.tex` source. Do not move `.sty` files — they must be in the same directory as the `.tex` file.

### MATLAB Listings
Use the `listings` package with a custom `MATLAB` language style for inline code blocks. Syntax highlighting is pre-configured in the preamble.

### Figuras Directory
Each conference folder contains a `Figuras/` subdirectory with all images used in that presentation. Image paths in `.tex` files are relative (e.g., `Figuras/nombre_imagen`).

## MATLAB Code

Scripts are standalone `.m` files — no toolbox dependencies beyond MATLAB Optimization Toolbox (used for `ga()`, `fmincon()`) and basic plotting. Run directly in MATLAB R2025b.

Key implementations:
- `con (13) PSO/` — PSO and MOPSO benchmark implementations
- `CLONALG/` — Clonal Selection Algorithm with 7 benchmark functions
- `EXAMPLES/` — Standalone GA and optimization examples
- `SimulatedAnnealing/` — SA implementations with Ackley and other functions

## Repository Structure

```
conf (N) [Topic]/        # Numbered conference folders (1–14)
├── sample.tex / main.tex
├── sample.pdf / main.pdf
├── *.m                  # MATLAB implementations
├── *.sty                # Beamer theme files (co-located)
└── Figuras/             # Images for the presentation

Evolutionary Computation in Industrial Engineering/
└── Evidencias/          # Compiled PDFs from all 14 conferences

SimulatedAnnealing/      # SA-specific materials + markdown explanations
EXAMPLES/                # Isolated, runnable algorithm examples
CLONALG/                 # Clonal selection algorithm
Books/                   # Reference PDFs (do not modify)
```

## Auxiliary Files

LaTeX compilation generates `.aux`, `.log`, `.nav`, `.snm`, `.toc`, `.out`, `.fls`, `.fdb_latexmk` files. These are build artifacts — do not commit them. They are **not** in `.gitignore` currently, so be careful with `git add`.

## Evidence Organization

`copy_evidence.py` in `Evolutionary Computation in Industrial Engineering/` automatically copies compiled PDFs from conference folders into the `Evidencias/` subdirectory. Run with the conda `research` environment:
```bash
conda run -n research python copy_evidence.py
```
