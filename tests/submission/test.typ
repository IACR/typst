// A submission is anonymous: "Anonymous Submission" replaces the authors,
// there are no affiliations, ORCID icons or footnotes, and the running head
// on odd pages names the journal instead of the authors.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  version: "submission",
  title: (full: "An Anonymous Paper", short: "Short Title"),
  authors: (
    (
      name: "Alice",
      inst: 1,
      email: "alice@example.org",
      orcid: "0000-0002-1825-0097",
      footnote: "A footnote",
    ),
    (name: "Bob", inst: 2),
  ),
  affiliations: ("University A", "University B"),
)

#context assert.eq(document.author, ("hidden for submission",))

Page one.
#pagebreak()
Page two.
#pagebreak()
Page three.
