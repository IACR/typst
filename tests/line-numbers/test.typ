// Lines are numbered in submissions by default; `line-numbers` overrides
// that for any version.
#import "/src/iacrj.typ": iacrj

#let numbered(expected, ..args) = iacrj(
  journal: "cic",
  title: "T",
  authors: ("A",),
  ..args,
  context assert.eq(par.line.numbering != none, expected),
)

#numbered(false)
#numbered(true, version: "submission")
#numbered(true, line-numbers: true)
#numbered(false, version: "submission", line-numbers: false)
#numbered(true, version: "final", license: "CC-BY-4.0", line-numbers: true)
#numbered(false, version: "preprint", line-numbers: auto)
#assert(
  catch(() => iacrj(
    journal: "cic",
    title: "T",
    authors: ("A",),
    line-numbers: "yes",
  )[]).contains(
    "line-numbers",
  ),
)
