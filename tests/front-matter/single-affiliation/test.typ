// With a single affiliation, no affiliation numbers appear anywhere.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  title: "Single Affiliation",
  authors: ((name: "Alice", inst: 1), (name: "Bob", inst: 1, footnote: "A footnote for Bob")),
  affiliations: ("University of Second Choice",),
)

Body.
