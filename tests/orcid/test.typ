// The orcid() helper: accepted formats, normalization and rejected input.
#import "/src/iacrj.typ": orcid

#let dest(id) = orcid(id).dest
#let canonical = "https://orcid.org/0000-0002-1825-0097"

// Accepted spellings all link to the canonical URL.
#for id in (
  "0000-0002-1825-0097",
  "0000 0002 1825 0097",
  "0000000218250097",
  "  0000-0002-1825-0097  ",
  "https://orcid.org/0000-0002-1825-0097",
  "http://www.orcid.org/0000-0002-1825-0097",
  "ORCID.org/0000-0002-1825-0097",
) {
  assert.eq(dest(id), canonical, message: id)
}

// A check digit of 10 is written X, in either case.
#assert.eq(dest("0000-0002-9079-593X"), "https://orcid.org/0000-0002-9079-593X")
#assert.eq(dest("0000-0002-9079-593x"), "https://orcid.org/0000-0002-9079-593X")

// Wrong checksum.
#assert(catch(() => orcid("0000-0002-1825-0098")).contains("invalid checksum"))

// Malformed IDs.
#for id in ("", "0000-0002-1825-009", "0000-0002-1825-00977", "0000-0002-1825-X097", "abcd-0002-1825-0097") {
  assert(catch(() => orcid(id)).contains("is not a valid ORCID"), message: repr(id))
}

// Not a string.
#assert(catch(() => orcid(18250097)).contains("expected a string"))
