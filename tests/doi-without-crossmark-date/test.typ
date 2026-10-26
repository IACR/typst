// A DOI remains usable without inventing a Crossmark major-version date.
#import "/src/iacrj.typ": _iacrj

#show: _iacrj.with(
  iacrmetadata: "doi=10.62056/a66c0l2hd\n"
    + "date-received=2026-03-01\ndate-accepted=2026-08-01\n",
  journal: "cic",
  version: "final",
  license: "CC-BY-4.0",
  title: "DOI without Crossmark date",
  authors: ("Alice",),
)

// The license footer adds its own links and image.
#context {
  assert.eq(
    query(link)
      .map(it => it.dest)
      .filter(it => not it.starts-with("https://creativecommons.org/")),
    ("https://doi.org/10.62056/a66c0l2hd",),
  )
  assert.eq(query(image).filter(it => it.alt == "Check for updates").len(), 0)
}

Body.
