// With a single author, no affiliation numbers appear, even with several
// affiliations. The author footnote is just a letter, without a comma.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Single Author",
  authors: ((name: "Alice", inst: (1, 2), footnote: "A footnote for Alice"),),
  affiliations: ("University of Second Choice", "Vermont State University"),
)

Body.
