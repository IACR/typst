#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Single bibliography source",
  authors: ("Alice",),
  bibliography: "/tests/bibliography-single/works.bib",
)

A reference to @single.

#context {
  assert.eq(query(bibliography).len(), 1)
  assert.eq(query(<iacrj-meta>).first().value.citekeys, ("single",))
  // References sharing the main text's last page count towards both totals.
  assert.eq(query(<iacrj-meta>).first().value.pages, (full: 1, main: 1))
}
