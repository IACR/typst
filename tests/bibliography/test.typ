// Aliases and their uses must be parsed together, not as separate sources.
#import "/src/iacrj.typ": iacrj

#let labels = state("alphanumeric-labels", 0)
#show "Exa26": it => {
  labels.update(n => n + 1)
  it
}
#let saw-journal = state("saw-journal", false)
#show "Journal of Cross-File Aliases": it => {
  saw-journal.update(true)
  it
}

#show: iacrj.with(
  journal: "cic",
  title: "Bibliography sources",
  authors: ("Alice",),
  bibliography: (
    "tests/bibliography/strings.bib",
    "/tests/bibliography/works.bib",
  ),
)

A reference to @example.

#context assert(
  saw-journal.final(),
  message: "The cross-file alias was not expanded.",
)
#context {
  let entries = query(bibliography)
  assert.eq(entries.len(), 1)
  // Both the citation and its reference-list entry must carry the same label.
  assert.eq(labels.final(), 2)
  assert.eq(entries.first().sources, (
    read("strings.bib", encoding: none)
      + bytes("\n")
      + read("works.bib", encoding: none),
  ))
}
