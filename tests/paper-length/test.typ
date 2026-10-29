#import "/src/iacrj.typ": iacrj

#let with-bibliography = (
  sys.inputs.at("bibliography", default: "true") == "true"
)

// Put the references on a separate page to distinguish paper length from total
// length. This rule affects only the bibliography, not the paper boundary.
#show bibliography: it => {
  pagebreak()
  it
}

#show: iacrj.with(
  journal: "cic",
  title: "Paper length",
  authors: ("Alice",),
  bibliography: if with-bibliography {
    "/tests/bibliography-single/works.bib"
  } else { () },
)

First page of the paper.
// An earlier author-supplied marker must not determine the paper length.
#metadata("iacrj-paper-end")

#pagebreak()
Second page of the paper.
// Both counts must use physical pages, not the displayed page counter.
#counter(page).update(42)
#if with-bibliography [A reference to @single.]

#context {
  // The main count ends before bibliography-only pages; full includes them.
  assert.eq(query(<iacrj-meta>).first().value.pages, (
    full: if with-bibliography { 3 } else { 2 },
    main: 2,
  ))
  let ends = query(metadata.where(value: "iacrj-paper-end"))
  assert.eq(ends.len(), 2)
  assert.eq(ends.first().location().page(), 1)
  assert.eq(ends.last().location().page(), 2)
  assert.eq(counter(page).final().first(), if with-bibliography { 43 } else {
    42
  })
  if with-bibliography {
    assert.eq(query(bibliography).first().location().page(), 3)
  }
}
