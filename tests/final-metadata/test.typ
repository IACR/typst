// Publisher DOI metadata is used only in the final version, and only on page 1.
#import "/src/iacrj.typ": _iacrj, check-for-updates, config-journal, page-header

#let doi = "10.62056/a66c0l2hd"
#let doi-url = "https://doi.org/" + doi
#let date = "2026-07-24"
#let updates-url = (
  "https://crossmark.crossref.org/dialog/?doi=10.62056%2Fa66c0l2hd&domain=pdf&date_stamp="
    + date
)
#let publisher = (
  "volume=3\nissue=2\ndoi="
    + doi
    + "\ncrossmark-date="
    + date
    + "\ndate-received=2026-03-01\ndate-accepted=2026-06-01\n"
)

#assert.eq(check-for-updates(doi, date).dest, updates-url)
#assert.ne(check-for-updates(doi, "2026-07-25").dest, updates-url)
#assert.eq(
  check-for-updates("10.1234/a&b=c+#%é", date).dest,
  "https://crossmark.crossref.org/dialog/?doi=10.1234%2Fa%26b%3Dc%2B%23%25%C3%A9&domain=pdf&date_stamp="
    + date,
)

#show: _iacrj.with(
  iacrmetadata: publisher,
  journal: "cic",
  version: "final",
  license: "CC-BY-4.0",
  title: "Publisher metadata",
  authors: ("Alice",),
)

// These render nothing on physical page 1 even when publication links exist.
#for version in ("preprint", "submission") {
  page-header(
    "cic",
    version: version,
    doi: doi,
    crossmark-date: date,
  )
}
#context assert.eq(document.description, [#(
  config-journal.cic.journal.name + ", DOI: " + doi
)])

Page one.
#pagebreak()
Page two.

#context {
  // Preprint/submission calls above and later pages must add no publication links.
  let urls = query(link).map(it => it.dest)
  assert.eq(urls.filter(it => it == doi-url).len(), 1)
  assert.eq(urls.filter(it => it == updates-url).len(), 1)
}
