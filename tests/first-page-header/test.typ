// First-page header of a final ToSC/TCHES paper with a volume and number:
// the journal name, then ISSN, Vol., No. and the page count. tytanic cannot
// pass `--input iacrmetadata=...`, so the test calls _iacrj with the metadata.
#import "/src/iacrj.typ": _iacrj

#show: _iacrj.with(
  iacrmetadata: "volume=2025\nnumber=4\n",
  journal: "tches",
  version: "final",
  title: "First-Page Header",
  authors: ("Alice",),
)

Page one.
#pagebreak()
Page two.
