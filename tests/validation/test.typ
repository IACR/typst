// Argument validation of iacrj(). The template panics while parsing its
// arguments, before any layout, so `catch` sees the message.
#import "/src/iacrj.typ": _parse-iacrmetadata, affiliation-marker, iacrj

#let error(..args) = catch(() => iacrj(..args)[Body])
#assert(catch(() => affiliation-marker("2")).contains("expected an integer"))

// Bibliography sources must be a string or a tuple of nonempty strings.
#for bibliography in (none, 1, "", (1,), ("valid.bib", 1)) {
  assert(
    error(
      journal: "cic",
      title: "T",
      authors: ("A",),
      bibliography: bibliography,
    ).contains("iacrj.bibliography"),
  )
}

// Valid minimal calls.
#iacrj(journal: "cic", title: "T", authors: ("A",))[]
#iacrj(
  journal: "cic",
  title: (full: "Long Title", short: "Short"),
  authors: ((name: "A", inst: ("uni-a", "uni-b")),),
  affiliations: (
    uni-a: (name: "University A"),
    uni-b: "University B",
  ),
)[]

// Legacy positional affiliations and numeric references are rejected.
#for affiliations in (("University A",), (uni-a: 1)) {
  assert(
    error(
      journal: "cic",
      title: "T",
      authors: ("A",),
      affiliations: affiliations,
    ).contains("iacrj.affiliations"),
  )
}
#for inst in (1, (1,), ("uni-a", 2)) {
  assert(
    error(
      journal: "cic",
      title: "T",
      authors: ((name: "A", inst: inst),),
      affiliations: (uni-a: "University A"),
    ).contains("iacrj.authors"),
  )
}

// References must exist even with a single author/affiliation or anonymity.
#for version in ("preprint", "submission") {
  for inst in ("missing", ("uni-a", "missing")) {
    assert(
      error(
        journal: "cic",
        version: version,
        title: "T",
        authors: ((name: "A", inst: inst),),
        affiliations: (uni-a: "University A"),
      ).contains("unknown affiliation key"),
    )
  }
}
#assert(
  error(
    journal: "cic",
    title: "T",
    authors: ((name: "A", inst: "uni-a"),),
  ).contains("unknown affiliation key"),
)

// At least one author is required.
#assert(
  error(journal: "cic", title: "T", authors: ()).contains("iacrj.authors"),
)

// An empty title is rejected.
#assert(
  error(journal: "cic", title: "", authors: ("A",)).contains("iacrj.title"),
)

// Unknown keys are rejected (strict mode), e.g. a misspelled field.
#assert(
  error(journal: "cic", title: (full: "T", shrot: "S"), authors: (
    "A",
  )).contains("shrot"),
)
#assert(
  error(journal: "cic", title: "T", authors: (
    (name: "A", affiliation: 1),
  )).contains("affiliation"),
)

// The abstract must be markup source, not content.
#assert(
  error(journal: "cic", title: "T", authors: ("A",), abstract: [x]).contains(
    "read(\"abstract.typ\")",
  ),
)

// The journal is required and is one of cic, tosc and tches.
#assert(error(title: "T", authors: ("A",)).contains("`journal` is required"))
#iacrj(journal: "tosc", title: "T", authors: ("A",))[]
#iacrj(journal: "tches", title: "T", authors: ("A",))[]
#assert(
  error(journal: "eprint", title: "T", authors: ("A",)).contains(
    "iacrj.journal",
  ),
)

// The version is one of preprint (the default), submission and final.
#iacrj(journal: "cic", version: "submission", title: "T", authors: ("A",))[]
#iacrj(
  journal: "cic",
  version: "final",
  license: "CC-BY-4.0",
  title: "T",
  authors: ("A",),
)[]
#assert(
  error(journal: "cic", version: "draft", title: "T", authors: ("A",)).contains(
    "iacrj.version",
  ),
)

// A submission hides the authors unless notanonymous is set.
#iacrj(journal: "cic", version: "submission", title: "T", authors: ("Alice",))[
  #context assert.eq(document.author, ("hidden for submission",))
]
#iacrj(
  journal: "cic",
  version: "submission",
  notanonymous: true,
  title: "T",
  authors: ("Alice",),
)[
  #context assert.eq(document.author, ("Alice",))
]
#assert(
  error(journal: "cic", notanonymous: "yes", title: "T", authors: (
    "A",
  )).contains("iacrj.notanonymous"),
)

// Volume and issue come from the publisher's iacrmetadata, never from the
// document.
#assert(
  error(journal: "cic", title: "T", authors: ("A",), volume: 5).contains(
    "volume",
  ),
)
#assert(
  error(
    journal: "cic",
    title: "T",
    authors: ("A",),
    iacrmetadata: "volume=5",
  ).contains("publisher"),
)
#let no-metadata = (
  volume: none,
  issue: none,
  doi: none,
  crossmark-date: none,
  date-received: none,
  date-accepted: none,
  date-revised: none,
  date-final: none,
)
#assert.eq(_parse-iacrmetadata(none), no-metadata)
// A supplied file must have the received and accepted dates.
#let dates = "date-received=2026-03-01\ndate-accepted=2026-08-01\n"
#let empty-metadata = (
  no-metadata + (date-received: "2026-03-01", date-accepted: "2026-08-01")
)
#for (metadata, message) in (
  ("", "must have date-received and date-accepted."),
  ("volume=5\n", "must have date-received and date-accepted."),
  ("date-received=2026-03-01\n", "must have date-accepted."),
  ("date-accepted=2026-08-01\n", "must have date-received."),
  (
    "date-received=\n" + "date-accepted=2026-08-01\n",
    "must have date-received.",
  ),
) {
  assert(
    catch(() => _parse-iacrmetadata(metadata)).contains(
      "iacrj: iacrmetadata " + message,
    ),
    message: repr(metadata),
  )
}
#assert.eq(_parse-iacrmetadata(dates), empty-metadata)
#assert.eq(
  _parse-iacrmetadata(dates + "volume=5\nissue=3\n"),
  empty-metadata + (volume: 5, issue: 3),
)
#assert.eq(
  _parse-iacrmetadata(
    dates + " volume = 5 \n\ndoi=10.62056/a1b2=c\nunknown=value\n",
  ),
  empty-metadata + (volume: 5, doi: "10.62056/a1b2=c"),
)
#assert.eq(
  _parse-iacrmetadata(dates + "doi=\ncrossmark-date=\n"),
  empty-metadata,
)
#assert.eq(
  _parse-iacrmetadata(dates + "crossmark-date=2026-07-24\n"),
  empty-metadata + (crossmark-date: "2026-07-24"),
)
#assert.eq(
  _parse-iacrmetadata(dates + "crossmark-date=2024-02-29\n"),
  empty-metadata + (crossmark-date: "2024-02-29"),
)
// Strict format validation rejects missing padding, extra parts and query injection.
#for date in (
  "2026-7-24",
  "2026-07-4",
  "26-07-24",
  "2026",
  "2026-09",
  "2026-09-30-extra",
  "2026-07-24&domain=html",
  "not-a-date",
  "2026--31",
) {
  assert(
    catch(() => _parse-iacrmetadata("crossmark-date=" + date)).contains(
      "expected YYYY-MM-DD",
    ),
    message: date,
  )
}
// Correctly formatted dates must also represent a real calendar date.
#for date in ("2026-02-29", "2026-13-01", "2026-04-31", "2026-09-31") {
  assert(
    catch(() => _parse-iacrmetadata("crossmark-date=" + date)) != none,
    message: date,
  )
}
#assert(
  catch(() => _parse-iacrmetadata("crossmark-date=2026-09-31")).contains(
    "date is invalid",
  ),
)
#assert(
  error(
    journal: "cic",
    title: "T",
    authors: ("A",),
    doi: "10.62056/a1b2",
  ).contains("doi"),
)
#assert(
  error(
    journal: "cic",
    title: "T",
    authors: ("A",),
    crossmark-date: "2026-07-24",
  ).contains("crossmark-date"),
)
#assert(
  error(
    journal: "cic",
    title: "T",
    authors: ("A",),
    crossmark-url: "https://example.org/updates",
  ).contains("crossmark-url"),
)
#assert(
  catch(() => _parse-iacrmetadata("volume=five")).contains("whole number"),
)
#assert(catch(() => _parse-iacrmetadata("volume 5")).contains("key=value"))
#assert(
  catch(() => _parse-iacrmetadata("volume=5\nvolume=6")).contains(
    "more than once",
  ),
)
#for value in ("\"10.62056/a1b2\"", "'10.62056/a1b2'", "\"5\"") {
  assert(
    catch(() => _parse-iacrmetadata("doi=" + value)).contains("quoted"),
    message: value,
  )
}
#for doi in (
  "https://doi.org/10.62056/a1b2",
  "doi:10.62056/a1b2",
  "10.62056",
  "10.62056/",
  "10.62056/a b",
  "11.62056/a1b2",
) {
  assert(
    catch(() => _parse-iacrmetadata("doi=" + doi)).contains("must be a DOI"),
    message: doi,
  )
}

// The license is an SPDX identifier of a supported Creative Commons license,
// and the final version requires one.
#for license in ("CC-BY-4.0", "CC-BY-SA-4.0", "CC0-1.0") {
  iacrj(journal: "cic", license: license, title: "T", authors: ("A",))[]
}
#for license in ("MIT", "CC-BY-3.0", "cc-by-4.0", "CC BY 4.0", 4) {
  assert(
    error(journal: "cic", license: license, title: "T", authors: (
      "A",
    )).contains(
      "iacrj.license",
    ),
    message: repr(license),
  )
}
#assert(
  error(journal: "cic", version: "final", title: "T", authors: ("A",)).contains(
    "requires a license",
  ),
)

// The publisher's received, accepted, revised and final dates are YYYY-MM-DD.
#assert.eq(
  _parse-iacrmetadata(
    "date-received=2026-03-01\ndate-accepted=2026-08-01\ndate-revised=2026-08-15\ndate-final=2026-08-23\n",
  ),
  empty-metadata
    + (
      date-received: "2026-03-01",
      date-accepted: "2026-08-01",
      date-revised: "2026-08-15",
      date-final: "2026-08-23",
    ),
)
#for key in ("date-received", "date-accepted", "date-revised", "date-final") {
  assert(
    catch(() => _parse-iacrmetadata(key + "=2026-8-1")).contains(
      "invalid " + key + "; expected YYYY-MM-DD",
    ),
    message: key,
  )
}

// Received <= accepted <= final and received <= revised <= final; equal dates
// are allowed, the revised and final dates are optional, and the revised date
// may come before or after acceptance.
#assert.eq(
  _parse-iacrmetadata(
    "date-received=2026-08-01\ndate-accepted=2026-08-01\ndate-final=2026-08-01\n",
  ).date-final,
  "2026-08-01",
)
#assert.eq(
  _parse-iacrmetadata(
    "date-received=2026-03-01\ndate-accepted=2026-03-01\n",
  ).date-final,
  none,
)
#for revised in ("2026-05-01", "2026-08-15") {
  assert.eq(
    _parse-iacrmetadata(
      "date-received=2026-03-01\ndate-accepted=2026-06-01\ndate-revised="
        + revised
        + "\ndate-final=2026-08-23\n",
    ).date-revised,
    revised,
  )
}
#for (metadata, message) in (
  (
    "date-received=2026-08-02\ndate-accepted=2026-08-01\n",
    "date-received (2026-08-02) must not be after date-accepted (2026-08-01)",
  ),
  (
    "date-accepted=2026-08-24\ndate-final=2026-08-23\n",
    "date-accepted (2026-08-24) must not be after date-final (2026-08-23)",
  ),
  (
    "date-received=2027-01-01\ndate-final=2026-08-23\n",
    "date-received (2027-01-01) must not be after date-final (2026-08-23)",
  ),
  (
    "date-received=2026-03-01\ndate-revised=2026-02-28\n",
    "date-received (2026-03-01) must not be after date-revised (2026-02-28)",
  ),
  (
    "date-revised=2026-08-24\ndate-final=2026-08-23\n",
    "date-revised (2026-08-24) must not be after date-final (2026-08-23)",
  ),
) {
  assert(
    catch(() => _parse-iacrmetadata(metadata)).contains(message),
    message: metadata,
  )
}
