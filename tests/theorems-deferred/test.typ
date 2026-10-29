// Restatements reuse the original theorem data, without replaying counters.
#import "/src/iacrj.typ": iacrj, proof, theorem, thm-restate
#import "@preview/ctheorems:2.0.0": thm-fmt-block, thm-state

// Observe the number passed to the real formatter at each rendering, including
// the appendix rendering (which is not a new entry in thm-stored).
#let record-format(thm) = {
  metadata((restated-number: thm.number))
  thm-fmt-block(thm)
}

#show: iacrj.with(
  journal: "cic",
  title: "Deferred proofs and restated theorems",
  authors: ("Alice",),
  abstract: "Ordinary proofs stay in place; deferred proofs appear in an appendix.",
)

= Main results

#theorem[An ordinary result, not selected for restatement.] <ordinary-theorem>
#proof[of @ordinary-theorem][
  An ordinary proof appears only here.#metadata("ordinary-proof-body")
]

#theorem(restate: true, fmt: record-format)[Deferred result][
  The theorem is stated here and repeated in the appendix.
  #metadata("restated-theorem-body")
] <deferred-theorem>
#proof([of @deferred-theorem], defer: true)[
  This proof appears only in the appendix.#metadata("deferred-proof-body")
]

#theorem[A later main-body result is Theorem 3.] <third-theorem>

The proof of @deferred-theorem is deferred, not the statement itself.

#pagebreak()
#metadata("appendix-start") <appendix-boundary>
#heading(numbering: none)[Appendix: Deferred proofs]
#thm-restate()

#theorem[A new result after restatement is Theorem 4.] <fourth-theorem>

#context {
  let boundary = query(<appendix-boundary>).first().location()
  let before(sel) = query(selector(sel).before(boundary))
  let after(sel) = query(selector(sel).after(boundary))

  let repeated = metadata.where(value: "restated-theorem-body")
  assert.eq(before(repeated).len(), 1)
  assert.eq(after(repeated).len(), 1)
  let ordinary = metadata.where(value: "ordinary-proof-body")
  assert.eq(before(ordinary).len(), 1)
  assert.eq(after(ordinary).len(), 0)
  let deferred = metadata.where(value: "deferred-proof-body")
  assert.eq(before(deferred).len(), 0)
  assert.eq(after(deferred).len(), 1)

  // The appendix uses the original number 2, even though the main-body
  // theorem counter has already advanced to 3.
  let rendered = metadata.where(value: (restated-number: "2"))
  assert.eq(before(rendered).len(), 1)
  assert.eq(after(rendered).len(), 1)
  let stored = thm-state.thm-stored.final()
  let theorems = stored.filter(it => it.supplement == "Theorem")
  assert.eq(theorems.map(it => it.number), ("1", "2", "3", "4"))
  assert.eq(theorems.map(it => it.restate), (false, true, false, false))
  let proofs = stored.filter(it => it.supplement == "Proof")
  assert.eq(proofs.map(it => it.defer), (false, true))
  assert(proofs.all(it => it.number == none))

  // One QED for the ordinary proof in the main body, one for the deferred
  // proof in the appendix, with none from the repeated theorem.
  let qeds = metadata.where(value: "thm-qed-symbol")
  assert.eq(before(qeds).len(), 1)
  assert.eq(after(qeds).len(), 1)
  assert.eq(query(qeds).len(), proofs.len())

  let appendix = query(heading)
    .filter(it => (
      it.body == [Appendix: Deferred proofs]
    ))
    .first()
  assert.eq(appendix.numbering, none)
  assert.eq(
    after(deferred).first().location().page(),
    appendix.location().page(),
  )
}
