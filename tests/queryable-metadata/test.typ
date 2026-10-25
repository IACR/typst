// The validated metadata can be queried, e.g. by `typst eval --in`.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "tosc",
  version: "submission",
  title: (full: "A queryable paper", short: "Queryable"),
  authors: ((name: "Alice", inst: "uni-a"),),
  affiliations: (uni-a: "University A"),
  abstract: "An abstract with $x^2$.",
  keywords: ("one", "two"),
)

First page.
#pagebreak()
Second page.

#context {
  let records = query(<iacrj-meta>)
  assert.eq(records.len(), 1)
  let meta = records.first().value
  assert.eq(meta.journal, "tosc")
  assert.eq(meta.version, "submission")
  assert.eq(meta.title, (full: "A queryable paper", short: "Queryable"))
  // An anonymous submission is redacted here too.
  assert.eq(meta.authors, ())
  assert.eq(meta.affiliations, (:))
  assert.eq(meta.keywords, ("one", "two"))
  assert.eq(meta.abstract, "An abstract with $x^2$.")
  assert.eq(meta.bibliography, ())
  assert.eq(meta.pages, 2)
  assert("doi" not in meta)
}
