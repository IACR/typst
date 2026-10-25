// LaTeX uses a normal 12pt baseline step from keywords to a following paragraph.
#import "/src/iacrj.typ": iacrj

#show regex("Keywords:|last keyword|Body text"): it => {
  it
  box(width: 0pt, height: 0pt, metadata(it.text))
}

#for (i, words) in (
  ("last keyword",),
  (
    "a deliberately long keyword phrase",
    "another deliberately long keyword phrase",
    "a third deliberately long keyword phrase",
    "last keyword",
  ),
).enumerate() {
  if i > 0 { pagebreak() }
  iacrj(
    journal: "cic",
    title: "Keyword spacing",
    authors: ("Alice",),
    keywords: words,
  )[
    Body text follows the keywords.
  ]
}

#context {
  let positions(value) = query(metadata.where(value: value)).map(it => it.location().position())
  let labels = positions("Keywords:")
  let keywords = positions("last keyword")
  let bodies = positions("Body text")
  assert.eq(keywords.len(), 2)
  assert.eq(bodies.len(), 2)
  for i in range(2) {
    assert.eq(keywords.at(i).page, bodies.at(i).page)
    assert(calc.abs(bodies.at(i).y - keywords.at(i).y - 12pt) < 0.01pt)
  }
  assert(calc.abs(keywords.at(0).y - labels.at(0).y) < 0.01pt)
  assert(keywords.at(1).y - labels.at(1).y >= 12pt)
}
