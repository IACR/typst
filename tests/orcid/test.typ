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

// The icon is 0.7em tall, as tall as the line, with a 0.2em left inset.
#assert.eq(orcid(canonical).body.inset, (left: 0.2em))
#let described = orcid(canonical, alt: "ORCID record for Alice")
#assert.eq(described.dest, canonical)
#assert.eq(described.body.body.alt, "ORCID record for Alice")
#for size in (9pt, 10pt, 12pt) {
  block({
    set text(size: size)
    context {
      let default = measure(orcid(canonical))
      assert(calc.abs(default.height - 0.7 * size) < 0.001pt)
      assert(calc.abs(default.width - 0.9 * size) < 0.001pt)

      for margin in (0pt, 3pt, 0.4em) {
        let icon = orcid(canonical, hor-margin: margin)
        assert.eq(icon.body.inset, (left: margin))
        assert.eq(icon.dest, canonical)
        let actual = measure(icon)
        assert(calc.abs(actual.height - 0.7 * size) < 0.001pt)
        assert(
          calc.abs(actual.width - (0.7 * size + margin.to-absolute()))
            < 0.001pt,
        )
      }

      for height in (6pt, 10pt, 0.8em) {
        let icon = orcid(canonical, height: height)
        assert.eq(icon.dest, canonical)
        let actual = measure(icon)
        let expected = height.to-absolute()
        assert(calc.abs(actual.height - expected) < 0.001pt)
        assert(calc.abs(actual.width - (expected + 0.2 * size)) < 0.001pt)
      }
    }
  })
}

// Wrong checksum.
#assert(catch(() => orcid("0000-0002-1825-0098")).contains("invalid checksum"))

// Malformed IDs.
#for id in (
  "",
  "0000-0002-1825-009",
  "0000-0002-1825-00977",
  "0000-0002-1825-X097",
  "abcd-0002-1825-0097",
) {
  assert(
    catch(() => orcid(id)).contains("is not a valid ORCID"),
    message: repr(id),
  )
}

// Not a string.
#assert(catch(() => orcid(18250097)).contains("expected a string"))
