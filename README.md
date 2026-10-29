# Vizing's theorem and equitable edge colourings in Lean 4

Author and maintainer: **Juan Pablo Traverso Gianini**. Licence: Apache-2.0 (see `LICENSE`).

This repository formalizes, for finite simple graphs `G` with maximum degree `Δ(G)`:

1. **Vizing's theorem (1964).** `G` has a proper edge colouring with `Δ(G) + 1` colours: its line
   graph is `(Δ(G) + 1)`-colourable, so `χ'(G) ≤ Δ(G) + 1`.
2. **Equitable edge colourings (McDiarmid 1972).** For every `c ≥ Δ(G) + 1` there is a proper edge
   colouring with colours `Fin c` in which any two colour classes differ in size by at most one
   (unused colours count as empty classes).
3. **Lower bound and class 1 / class 2** (version 2). `Δ(G) ≤ χ'(G)`, hence `χ'(G) = Δ(G)` or
   `χ'(G) = Δ(G) + 1`.

The audited statements are in [`Challenge.lean`](Challenge.lean), which imports only Mathlib; the
proofs are in [`Solution.lean`](Solution.lean). [`comparator.json`](comparator.json) lists the
compared theorems, [`MATHLIB_DEFINITIONS.md`](MATHLIB_DEFINITIONS.md) reproduces verbatim the
Mathlib definitions used by the statements, and [`formalization.yaml`](formalization.yaml)
records provenance, sources and process.

## How the proofs go

* **Vizing** (`LeanPool/Vizing/Basic`, `Fan`, `Kempe`, `Endpoints`, `Step`, `Main`). Partial edge
  colourings are extended one edge at a time. To colour an uncoloured edge `xy`, build a maximal
  fan at `x` and use a Kempe chain (an alternating path of two colours) to free a colour at the
  end of the fan, then rotate the fan. With `Δ + 1` colours every vertex misses a colour, which
  is what makes each step possible.
* **Equitable rebalancing** (`ColourClasses`, `EquitableDefinitions`, `Equitable`, `Corollaries`).
  If two colour classes differ in size by at least two, the subgraph they span is a union of
  alternating paths and cycles, and one path has more edges of the larger colour; swapping its
  colours keeps the colouring proper and strictly decreases the sum of squares of the class sizes.
  Iterating gives an equitable colouring on the same palette.

Provenance of the library modules:

* **Copied verbatim from Lean Pool.** `LeanPool/Vizing/{Basic, ColourClasses, Corollaries,
  Endpoints, Equitable, EquitableDefinitions, Fan, Kempe, LineGraphColouring, Main, Step}.lean`
  are the author's contribution to [Lean Pool](https://github.com/LeanPool/lean-pool) (PR #578),
  byte-identical to Lean Pool commit `26ce45d3871e5560a8baffa4d49a8942b1d20a24` (same git blob
  hashes); they were first developed in the Lean freeze of the author's Paper IV on Erdős problem
  #81. Lean Pool's generated aggregate `LeanPool/Vizing/Imports.lean` is not included.
* **Changed.** The root module `LeanPool/Vizing.lean` is Lean Pool's with one added line,
  `public import LeanPool.Vizing.LowerBound`.
* **Added in version 2, not in Lean Pool.** `LeanPool/Vizing/LowerBound.lean` (the lower bound
  `Δ(G) ≤ χ'(G)` and the class 1 / class 2 dichotomy). The lower bound is adapted from
  `PaperV.maxDegree_le_edgeChromaticNumber` in the author's Erdős #81 Paper V formalization,
  [`preprints/PAPER_V/05_formalization/lean/PaperV/ChromaticIndex.lean`](https://github.com/jtraverso/erdos-81-chordal-clique-partitions/blob/3cbd90eed41af7e86ac6f1f4b8c796e20a5e661f/preprints/PAPER_V/05_formalization/lean/PaperV/ChromaticIndex.lean)
  in `jtraverso/erdos-81-chordal-clique-partitions` at commit
  `3cbd90eed41af7e86ac6f1f4b8c796e20a5e661f`; the version here drops its `Nonempty V` hypothesis.
  The dichotomy is new.

Other Lean formalizations of Vizing's theorem exist; this one is not claimed to be the first.

## Scope

* Finite vertex types with decidable adjacency; no `sorry`, no custom axioms (only `propext`,
  `Classical.choice`, `Quot.sound`).
* The upper bound `χ' ≤ Δ + 1`, the lower bound `χ' ≥ Δ` and the dichotomy `χ' ∈ {Δ, Δ + 1}`
  (`LeanPool/Vizing/LowerBound.lean`, adapted from the author's Erdős #81 Paper V formalization:
  the edges at a vertex of maximum degree form a clique of the line graph). Which of the two
  classes a graph belongs to is not addressed.

## Sources

* V. G. Vizing, *On an estimate of the chromatic class of a p-graph* (Russian), Diskret. Analiz 3
  (1964) 25–30.
* C. McDiarmid, *The solution of a timetabling problem*, IMA J. Appl. Math. 9 (1972) 23–34
  (a proper edge colouring with `k` colours can be made equitable with any `k' ≥ k` colours; the
  equitable theorem here is this statement with `k = Δ + 1` from Vizing).
* D. de Werra, *Equitable colorations of graphs*, Rev. Française Informat. Recherche
  Opérationnelle 5 (1971) R-3, 3–8 (background).

## Authorship and use of AI

The results and the proof route were chosen by the author; the Lean code was written with AI
assistance (provenance recorded as AI in Lean Pool) and checked mechanically with Lean. See
`formalization.yaml` for details.

## Building

Lean `v4.35.0-rc3`, Mathlib `c55e6e786f49471c72fbddbec5415808896aec1e`:

```bash
lake exe cache get
lake build
```
