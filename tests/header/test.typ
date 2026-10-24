// Running heads: none on page 1; from page 2 on, the authors (odd pages) or
// the short title (even pages) with the page number, above a rule across the
// text width.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  title: (full: "A Long Title for the Header Test", short: "Short Title"),
  authors: ("Alice", "Bob"),
)

Page one.
#pagebreak()
Page two.
#pagebreak()
Page three.
