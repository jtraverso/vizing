/-
Copyright (c) 2026 Juan Pablo Traverso Gianini. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Juan Pablo Traverso Gianini
-/
module

public import Mathlib
public import LeanPool.Vizing
public import LeanPool.Vizing.Main

/-!
# Proofs of the statements in `Challenge.lean`

Vizing's theorem is `LeanPool.Vizing.lineGraph_colorable` (fans and Kempe chains,
`LeanPool/Vizing/`); the equitable version is `LeanPool.Vizing.exists_equitable_edge_colouring`
(balancing a Vizing colouring by alternating-component moves that decrease the square energy).
-/

@[expose] public section

namespace Vizing

/-- **Vizing's theorem.** The line graph of a finite simple graph `G` is `(Δ(G) + 1)`-colourable:
`G` has a proper edge colouring with `Δ(G) + 1` colours. -/
theorem lineGraph_colorable {V : Type*} [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj] :
    G.lineGraph.Colorable (G.maxDegree + 1) :=
  LeanPool.Vizing.lineGraph_colorable G

/-- **Vizing's theorem**, chromatic-index form: `χ'(G) ≤ Δ(G) + 1`. -/
theorem lineGraph_chromaticNumber_le {V : Type*} [Fintype V] (G : SimpleGraph V)
    [DecidableRel G.Adj] : G.lineGraph.chromaticNumber ≤ (G.maxDegree : ℕ∞) + 1 :=
  SimpleGraph.lineGraph_chromaticNumber_le_maxDegree_succ G

/-- **Equitable edge colourings.** For every `c ≥ Δ(G) + 1`, `G` has a proper edge colouring with
colours `Fin c` whose colour classes differ in size by at most one. -/
theorem exists_equitable_edge_colouring {V : Type*} [Fintype V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (c : ℕ) (hc : G.maxDegree + 1 ≤ c) :
    ∃ colour : Sym2 V → Fin c,
      (∀ e ∈ G.edgeFinset, ∀ f ∈ G.edgeFinset, e ≠ f → colour e = colour f →
        ∀ v ∈ e, v ∉ f) ∧
      ∀ a b : Fin c, (G.edgeFinset.filter fun e => colour e = a).card ≤
        (G.edgeFinset.filter fun e => colour e = b).card + 1 := by
  classical
  obtain ⟨colour, hp, heq, -⟩ := LeanPool.Vizing.exists_equitable_edge_colouring G c hc
  refine ⟨colour, fun e he f hf hef hcol v hve hvf => ?_, fun a b => heq a b⟩
  exact Finset.disjoint_left.1 (hp e he f hf hef hcol) (Sym2.mem_toFinset.2 hve)
    (Sym2.mem_toFinset.2 hvf)

end Vizing
