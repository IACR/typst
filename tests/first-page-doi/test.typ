// The final CiC header has a DOI and Crossmark badge on physical page 1 only.
#import "/src/iacrj.typ": config, page-header

#let doi = "10.62056/a66c0l2hd"
#let updates-url = "https://crossmark.crossref.org/dialog/?doi=10.62056%2Fa66c0l2hd&domain=pdf&date_stamp=2026-07-24"


#set text(..config.text)
#set par(..config.par)
#set page(..config.page, header: page-header(
  config.journals.cic,
  title: "Short title",
  authors: ((name: "Alice"),),
  version: "final",
  volume: 3,
  issue: 2,
  doi: doi,
  crossmark-date: "2026-07-24",
))

#show link: set text(fill: config.colors.url)

Page one.
#pagebreak()
Page two.

#context {
  let links = query(link)
  assert.eq(links.map(it => it.dest), ("https://doi.org/" + doi, updates-url))
  assert(links.all(it => it.location().page() == 1))
  let images = query(image)
  assert.eq(images.len(), 1)
  assert.eq(images.first().alt, "Check for updates")
}
