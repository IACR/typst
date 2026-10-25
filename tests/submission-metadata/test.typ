// Private metadata must not affect anonymous content, including hidden content.
#import "/src/iacrj.typ": iacrj, title-block

#let author = (
  name: "PRIVATE Alice",
  surname: "PRIVATE Surname",
  inst: (1,),
  email: "PRIVATE@example.org",
  orcid: "0000-0002-1825-0097",
  footnote: "PRIVATE author note",
)
#let affiliation = (
  name: "PRIVATE University",
  department: "PRIVATE Department",
  city: "PRIVATE City",
  country: "PRIVATE Country",
)
#let submission(authors, affiliations) = iacrj(
  journal: "cic",
  version: "submission",
  title: "An anonymous paper",
  authors: authors,
  affiliations: affiliations,
)[
  #context assert.eq(document.author, ("hidden for submission",))
  Anonymous body.
]

#let original = submission((author,), (affiliation,))

// Content equality is not a complete leak check: context blocks compare equal
// even when they capture different metadata, so they might bypass this check.
// Also lay out every variant below to exercise deferred headers and metadata.
#show regex("PRIVATE"): it => panic(
  "Private author or affiliation text leaked.",
)

#original
#for change in (
  (name: "PRIVATE Bob"),
  (surname: "PRIVATE Other Surname"),
  (inst: (2,)),
  (email: "PRIVATE-other@example.org"),
  (orcid: "0000-0002-9079-593X"),
  (footnote: "PRIVATE other author note"),
) {
  let changed = submission((author + change,), (affiliation,))
  assert.eq(changed, original)
  changed
}

#let anonymous-title = title-block(title: "An anonymous paper", authors: ())
#for change in (
  (:),
  (name: "PRIVATE Other University"),
  (department: "PRIVATE Other Department"),
  (city: "PRIVATE Other City"),
  (country: "PRIVATE Other Country"),
) {
  let affiliations = (affiliation + change,)
  let changed = submission((author,), affiliations)
  assert.eq(changed, original)
  // The public renderer must ignore affiliations even if supplied directly.
  assert.eq(
    title-block(
      title: "An anonymous paper",
      authors: (),
      affiliations: affiliations,
    ),
    anonymous-title,
  )
  changed
}

// Changing the number of authors or affiliations must not affect the output.
#let multiple = submission((author, author), (affiliation, affiliation))
#assert.eq(multiple, original)
#multiple

#context {
  assert.eq(query(footnote).len(), 0)
  assert.eq(query(link).len(), 0) // In particular, no hidden ORCID links.
}
