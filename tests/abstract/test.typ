// An abstract read from a file is rendered as markup, math included.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Abstract",
  authors: ("Alice",),
  abstract: read("abstract.typ"),
)

Body.
