/-
Copyright (c) 2026 Juan Pablo Traverso Gianini. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Juan Pablo Traverso Gianini
-/
module

public import Mathlib

/-!
# Vizing's theorem and equitable edge colourings

This file states, for finite simple graphs `G` with maximum degree `Δ(G)`:

1. **Vizing's theorem (1964).** `G` has a proper edge colouring with `Δ(G) + 1` colours, i.e. its
   line graph is `(Δ(G) + 1)`-colourable (`Vizing.lineGraph_colorable`); equivalently
   `χ'(G) ≤ Δ(G) + 1` (`Vizing.lineGraph_chromaticNumber_le`).
2. **Equitable edge colourings.** For every `c ≥ Δ(G) + 1` there is a proper edge colouring of
   `G` with colours `Fin c` in which any two colour classes differ in size by at most one
   (`Vizing.exists_equitable_edge_colouring`; unused colours count as empty classes).

An edge is an element `e : Sym2 V` of `G.edgeSet`; a colouring `colour : Sym2 V → Fin c` is
proper on `G` if two distinct edges of `G` with the same colour share no vertex.

The Mathlib definitions used in these statements are reproduced verbatim, with file and line at
the pinned Mathlib revision, in `MATHLIB_DEFINITIONS.md` at the root of this repository.
-/

@[expose] public section

namespace Vizing

/-- **Vizing's theorem.** The line graph of a finite simple graph `G` is `(Δ(G) + 1)`-colourable:
`G` has a proper edge colouring with `Δ(G) + 1` colours. -/
theorem lineGraph_colorable {V : Type*} [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj] :
    G.lineGraph.Colorable (G.maxDegree + 1) := by
  sorry

/-- **Vizing's theorem**, chromatic-index form: `χ'(G) ≤ Δ(G) + 1`. -/
theorem lineGraph_chromaticNumber_le {V : Type*} [Fintype V] (G : SimpleGraph V)
    [DecidableRel G.Adj] : G.lineGraph.chromaticNumber ≤ (G.maxDegree : ℕ∞) + 1 := by
  sorry

/-- **Equitable edge colourings.** For every `c ≥ Δ(G) + 1`, `G` has a proper edge colouring with
colours `Fin c` whose colour classes differ in size by at most one. -/
theorem exists_equitable_edge_colouring {V : Type*} [Fintype V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (c : ℕ) (hc : G.maxDegree + 1 ≤ c) :
    ∃ colour : Sym2 V → Fin c,
      (∀ e ∈ G.edgeFinset, ∀ f ∈ G.edgeFinset, e ≠ f → colour e = colour f →
        ∀ v ∈ e, v ∉ f) ∧
      ∀ a b : Fin c, (G.edgeFinset.filter fun e => colour e = a).card ≤
        (G.edgeFinset.filter fun e => colour e = b).card + 1 := by
  sorry

/-- **Lower bound for the chromatic index.** `Δ(G) ≤ χ'(G)`: the edges at a vertex of maximum degree
are pairwise adjacent. -/
theorem maxDegree_le_lineGraph_chromaticNumber {V : Type*} [Fintype V] (G : SimpleGraph V)
    [DecidableRel G.Adj] : (G.maxDegree : ℕ∞) ≤ G.lineGraph.chromaticNumber := by
  sorry

/-- **Class 1 / Class 2.** The chromatic index of a finite simple graph is `Δ(G)` or `Δ(G) + 1`. -/
theorem lineGraph_chromaticNumber_eq_or {V : Type*} [Fintype V] (G : SimpleGraph V)
    [DecidableRel G.Adj] :
    G.lineGraph.chromaticNumber = (G.maxDegree : ℕ∞) ∨
      G.lineGraph.chromaticNumber = (G.maxDegree : ℕ∞) + 1 := by
  sorry

end Vizing
