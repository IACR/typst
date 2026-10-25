// A DOI remains usable without inventing a Crossmark major-version date.
#import "/src/iacrj.typ": _iacrj

#show: _iacrj.with(
  iacrmetadata: "doi=10.62056/a66c0l2hd\n",
  journal: "cic",
  version: "final",
  title: "DOI without Crossmark date",
  authors: ("Alice",),
)

#context {
  assert.eq(query(link).map(it => it.dest), (
    "https://doi.org/10.62056/a66c0l2hd",
  ))
  assert.eq(query(image).len(), 0)
}

Body.
