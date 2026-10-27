// Check actual line positions, not just the abstract's paragraph settings.
#import "/src/iacrj.typ": iacrj

#show regex("Abstract"): it => {
  it
  box(width: 0pt, height: 0pt, metadata("abstract-heading"))
}
#show: iacrj.with(
  journal: "cic",
  title: "Layout test",
  authors: ("Alice",),
  abstract: ```typ
    #let mark(name) = box(width: 0pt, height: 0pt, metadata(name))
    #mark("first-line")First line.#linebreak()
    #mark("second-line")Second line.
    $ sum_(i=1)^n i $
    #mark("continuation")Continuation after display math.

    #mark("new-paragraph")A new paragraph.
  ```.text,
)

#context {
  let position(name) = query(metadata.where(value: name))
    .first()
    .location()
    .position()
  let first = position("first-line")
  assert.eq(first.x, position("second-line").x)
  assert.eq(first.x, position("continuation").x)
  assert(calc.abs(position("new-paragraph").x - first.x - 13.5pt) < 0.01pt)
  assert(calc.abs(position("second-line").y - first.y - 10.8pt) < 0.01pt)
  assert(calc.abs(first.y - position("abstract-heading").y - 13.5pt) < 0.01pt)
}

Body.
