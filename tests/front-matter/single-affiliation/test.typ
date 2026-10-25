// With a single affiliation, no affiliation numbers appear anywhere.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Single Affiliation",
  authors: (
    (name: "Alice", inst: "uni-a"),
    (name: "Bob", inst: "uni-a", footnote: "A footnote for Bob"),
  ),
  affiliations: (uni-a: "University of Second Choice"),
)

Body.
