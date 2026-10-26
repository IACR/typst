// First-page header of a final ToSC/TCHES paper with a volume and issue:
// the journal name, then ISSN, Vol., No. and the page count. tytanic cannot
// pass `--input iacrmetadata=...`, so the test calls _iacrj with the metadata.
#import "/src/iacrj.typ": _iacrj

#show: _iacrj.with(
  iacrmetadata: "volume=2025\nissue=4\n"
    + "date-received=2026-03-01\ndate-accepted=2026-08-01\n",
  journal: "tches",
  version: "final",
  license: "CC-BY-4.0",
  title: "First-Page Header",
  authors: ("Alice",),
)

Page one.
#pagebreak()
Page two.
