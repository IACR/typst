// Running heads: on page 1 none (the journal header is only on the final
// version, see first-page-header); from page 2 on, the authors (odd pages) or
// the short title (even pages) with the page number, above a rule.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: (full: "A Long Title for the Header Test", short: "Short Title"),
  authors: ("Alice", "Bob"),
)

Page one.
#pagebreak()
Page two.
#pagebreak()
Page three.
