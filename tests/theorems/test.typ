// Compile-only: no direct thm-rules import or show rule should be necessary.
#import "/src/iacrj.typ": iacrj, lemma, problem, proposition, theorem
#import "/src/iacrj.typ": conjecture, corollary, definition, example, exercise
#import "/src/iacrj.typ": case, note, property, question, remark, solution
#import "/src/iacrj.typ": claim, proof, qedhere
// Inspect resolved numbers, not Typst's unrelated figure counter.
#import "@preview/ctheorems:2.0.0": thm-state

#let numbered = (
  ("Theorem", theorem),
  ("Proposition", proposition),
  ("Problem", problem),
  ("Lemma", lemma),
  ("Conjecture", conjecture),
  ("Corollary", corollary),
  ("Definition", definition),
  ("Example", example),
  ("Exercise", exercise),
  ("Property", property),
  ("Question", question),
  ("Solution", solution),
  ("Remark", remark),
  ("Note", note),
  ("Case", case),
)

#show: iacrj.with(
  journal: "cic",
  title: "Theorem environment regressions",
  authors: ("Alice",),
  abstract: "Independent counters, references, proofs, and accessible equations.",
)

= First section

A forward reference to @second-theorem must resolve as Theorem 2.

#theorem[Named result][The first theorem has an optional name.] <first-theorem>
#proposition[The first proposition.] <first-proposition>
#problem[The first problem.] <first-problem>
#lemma[The first lemma.] <first-lemma>
#conjecture[The first conjecture.] <first-conjecture>
#corollary[The first corollary.] <first-corollary>
#definition[The first definition.] <first-definition>
#example[The first example.] <first-example>
#exercise[The first exercise.] <first-exercise>
#property[The first property.] <first-property>
#question[The first question.] <first-question>
#solution[The first solution.] <first-solution>
#remark[The first remark.] <first-remark>
#note[The first note.] <first-note>
#case[The first case.] <first-case>
#claim[An unnumbered claim.] <first-claim>

#proof[An ordinary proof gets an automatic QED.] <ordinary-proof>

#proof[of @first-theorem][
  #math.equation(
    block: true,
    alt: "One plus one equals two.",
    $1 + 1 = 2. #qedhere$,
  ) <proof-equation>
] <equation-proof>

#proof[
  + First step.
  + Last step. #qedhere
] <enum-proof>

#proof[
  - First observation.
  - Last observation. #qedhere
] <list-proof>

Backward references: @first-theorem, @first-proposition, @first-problem,
@first-lemma, @first-conjecture, @first-corollary, @first-definition,
@first-example, @first-exercise, @first-property, @first-question,
@first-solution, @first-remark, @first-note, and @first-case.

// thm-rules rewrites equations, even outside a theorem or proof. Keep their
// alternative descriptions, both inline and display, covered by this fixture.
An inline equation: #math.equation(alt: "x equals one", $x = 1$) <inline-equation>.
#math.equation(
  block: true,
  alt: "Two plus two equals four.",
  $2 + 2 = 4$,
) <display-equation>

= Second section

#theorem[An unnamed theorem in a new section is Theorem 2.] <second-theorem>
#for (supplement, env) in numbered.slice(1) {
  env[The second #supplement in a new section is still numbered 2.]
}
#claim[Another claim still has no number.] <second-claim>

// Natural pagination, rather than forced page breaks inside the environments.
#theorem[Long result][
  Start.#metadata("theorem-start")

  #lorem(1400)

  End.#metadata("theorem-end")
] <long-theorem>

#proof[of @long-theorem][
  Start.#metadata("proof-start")

  #lorem(1400)

  End.#metadata("proof-end")
] <long-proof>

#context {
  let stored = thm-state.thm-stored.final()
  let counter-names = ()
  for (supplement, _) in numbered {
    let envs = stored.filter(it => it.supplement == supplement)
    let expected = if supplement == "Theorem" { ("1", "2", "3") } else {
      ("1", "2")
    }
    assert.eq(envs.map(it => it.number), expected)
    assert(envs.all(it => it.base == none and it.numbering == "1"))
    assert(envs.all(it => it.counter == envs.first().counter))
    counter-names.push(envs.first().counter)
  }
  assert.eq(counter-names.dedup().len(), numbered.len())
  assert.eq(
    stored.filter(it => it.supplement == "Theorem").map(it => it.name),
    (
      [Named result],
      none,
      [Long result],
    ),
  )

  let claims = stored.filter(it => it.supplement == "Claim")
  let proofs = stored.filter(it => it.supplement == "Proof")
  assert.eq(claims.len(), 2)
  assert.eq(proofs.len(), 5)
  assert((claims + proofs).all(it => (
    it.number == none and it.numbering == none
  )))

  // References must target the labelled theorem figure, not the heading or a
  // bibliography entry. Resolve its ctheorems state to check forward refs too.
  let refs = query(ref)
  assert.eq(refs.len(), 18) // 15 backward, one forward, two proof headings.
  for item in refs {
    let target = item.element
    assert.eq(target.func(), figure)
    assert.eq(target.kind, "thm-env")
    let marker = query(
      selector(<meta:thm-env-counter>).after(target.location()),
    ).first()
    let resolved = thm-state.thm-stored.at(marker.location()).last()
    let expected = if item.target == <second-theorem> { "2" } else if (
      item.target == <long-theorem>
    ) { "3" } else { "1" }
    assert.eq(resolved.number, expected)
  }

  // Each proof emits exactly one QED, including explicit math/list placement.
  let qeds = query(metadata.where(value: "thm-qed-symbol"))
  assert.eq(qeds.len(), proofs.len())
  // QED symbols also need descriptions for strict accessible PDF export.
  assert(query(math.equation).all(it => it.alt != none))
  for (i, thm) in stored.enumerate() {
    let next = stored.at(i + 1, default: none)
    let selector = selector(metadata.where(value: "thm-qed-symbol")).after(
      thm.loc,
    )
    if next != none {
      selector = selector.before(next.loc)
    }
    let own-qeds = query(selector)
    assert.eq(own-qeds.len(), if thm.supplement == "Proof" { 1 } else { 0 })
  }

  for (lbl, alt, is-block) in (
    (<proof-equation>, "One plus one equals two.", true),
    (<inline-equation>, "x equals one", false),
    (<display-equation>, "Two plus two equals four.", true),
  ) {
    let eq = query(lbl).first()
    assert.eq(eq.func(), math.equation)
    assert.eq(eq.alt, alt)
    assert.eq(eq.block, is-block)
  }

  for kind in ("theorem", "proof") {
    let start = query(metadata.where(value: kind + "-start"))
      .first()
      .location()
      .page()
    let end = query(metadata.where(value: kind + "-end"))
      .first()
      .location()
      .page()
    assert(end > start, message: kind + " must remain page-breakable")
  }
}
