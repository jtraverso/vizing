/-
Copyright (c) 2026 Juan Pablo Traverso Gianini. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Juan Pablo Traverso Gianini
-/
module

public import LeanPool.Vizing.Main

/-!
# The lower bound `Δ(G) ≤ χ'(G)` and the Class 1 / Class 2 dichotomy

The edges at a vertex of maximum degree are pairwise adjacent in the line graph, so they form a
clique of size `Δ(G)` there and `Δ(G) ≤ χ'(G)`. Together with Vizing's theorem
`χ'(G) ≤ Δ(G) + 1`, the chromatic index is `Δ(G)` or `Δ(G) + 1`.

This module is not part of the Lean Pool contribution. The lower bound is adapted from
`PaperV.maxDegree_le_edgeChromaticNumber` in `PaperV/ChromaticIndex.lean` of the author's Erdős #81
Paper V formalization (`jtraverso/erdos-81-chordal-clique-partitions` at commit
`3cbd90eed41af7e86ac6f1f4b8c796e20a5e661f`, `preprints/PAPER_V/05_formalization/lean`), without
its `Nonempty V` hypothesis.
-/

@[expose] public section

namespace LeanPool.Vizing

open SimpleGraph

variable {V : Type*} [Fintype V]

/-- **Lower bound for the chromatic index.** `Δ(G) ≤ χ'(G)`. -/
theorem maxDegree_le_lineGraph_chromaticNumber (G : SimpleGraph V) [DecidableRel G.Adj] :
    (G.maxDegree : ℕ∞) ≤ G.lineGraph.chromaticNumber := by
  classical
  rcases isEmpty_or_nonempty V with hV | hV
  · have : G.maxDegree = 0 := by
      rw [SimpleGraph.maxDegree, Finset.univ_eq_empty, Finset.image_empty]
      rfl
    rw [this]
    exact bot_le
  obtain ⟨v, hv⟩ := G.exists_maximal_degree_vertex
  have hsub : ∀ e ∈ G.incidenceFinset v, e ∈ G.edgeSet := by
    intro e he
    rw [mem_incidenceFinset] at he
    exact G.incidenceSet_subset v he
  have hvmem : ∀ e ∈ G.incidenceFinset v, v ∈ e := by
    intro e he
    rw [mem_incidenceFinset] at he
    exact he.2
  let emb : {x // x ∈ G.incidenceFinset v} ↪ ↑G.edgeSet :=
    ⟨fun e => ⟨e.1, hsub e.1 e.2⟩, fun a b h => Subtype.ext (by simpa using h)⟩
  let s : Finset ↑G.edgeSet := (G.incidenceFinset v).attach.map emb
  have hcard : s.card = G.degree v := by
    rw [Finset.card_map, Finset.card_attach, G.card_incidenceFinset_eq_degree]
  have hclique : (G.lineGraph).IsClique ↑s := by
    intro a ha b hb hab
    simp only [s, emb, Finset.coe_map, Set.mem_image, Finset.mem_coe, Finset.mem_attach,
      true_and, Subtype.exists, Function.Embedding.coeFn_mk] at ha hb
    obtain ⟨ea, hea, rfl⟩ := ha
    obtain ⟨eb, heb, rfl⟩ := hb
    refine ⟨hab, v, ?_, ?_⟩
    · change v ∈ ea
      exact hvmem ea hea
    · change v ∈ eb
      exact hvmem eb heb
  have hcl := hclique.card_le_chromaticNumber
  rw [hcard] at hcl
  rw [hv]
  exact hcl

/-- **Class 1 / Class 2.** The chromatic index of a finite simple graph is `Δ(G)` or `Δ(G) + 1`. -/
theorem lineGraph_chromaticNumber_eq_or (G : SimpleGraph V) [DecidableRel G.Adj] :
    G.lineGraph.chromaticNumber = (G.maxDegree : ℕ∞) ∨
      G.lineGraph.chromaticNumber = (G.maxDegree : ℕ∞) + 1 := by
  have hlo := maxDegree_le_lineGraph_chromaticNumber G
  have hhi := SimpleGraph.lineGraph_chromaticNumber_le_maxDegree_succ G
  set d := G.maxDegree
  set c := G.lineGraph.chromaticNumber
  have hcast : (d : ℕ∞) + 1 = ((d + 1 : ℕ) : ℕ∞) := by push_cast; rfl
  rw [hcast] at hhi
  have hfin : c ≠ ⊤ := ne_top_of_le_ne_top (ENat.coe_ne_top _) hhi
  lift c to ℕ using hfin with cn
  have h1 : d ≤ cn := by exact_mod_cast hlo
  have h2 : cn ≤ d + 1 := by exact_mod_cast hhi
  rcases (show cn = d ∨ cn = d + 1 by omega) with h | h
  · left
    rw [h]
  · right
    rw [h]
    push_cast
    rfl

end LeanPool.Vizing
