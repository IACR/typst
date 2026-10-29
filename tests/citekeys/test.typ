#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Cited keys",
  authors: ("Alice",),
  abstract: "The abstract cites @second before the main text.",
  bibliography: "/tests/citekeys/works.bib",
)

= A section <section>

An explicit citation to #cite(<first>), followed by a repeated shorthand
citation to @second and another explicit citation to #cite(<first>).
See @section for an ordinary cross-reference.

#context {
  let keys = query(<iacrj-meta>).first().value.citekeys
  // Include abstract citations and sort keys consistently across export targets.
  assert.eq(keys, ("first", "second"))
  assert(not keys.contains("uncited"))
  assert(not keys.contains("section"))
}
