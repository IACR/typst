// With a single author, no affiliation numbers appear, even with several
// affiliations. The author footnote is just a letter, without a comma.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Single Author",
  authors: (
    (
      name: "Alice",
      inst: ("uni-a", "uni-b"),
      footnote: "A footnote for Alice",
    ),
  ),
  affiliations: (
    uni-a: "University of Second Choice",
    uni-b: "Vermont State University",
  ),
)

Body.
