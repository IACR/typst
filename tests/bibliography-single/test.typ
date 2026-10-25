#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Single bibliography source",
  authors: ("Alice",),
  bibliography: "/tests/bibliography-single/works.bib",
)

A reference to @single.

#context assert.eq(query(bibliography).len(), 1)
