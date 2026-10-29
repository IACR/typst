// All versions support default, explicit auto, forced anonymous, and named modes.
#import "/src/iacrj.typ": iacrj

#show regex(".+"): it => {
  metadata((rendered-text: it.text))
  it
}

#let author = (
  name: "PRIVATE Alice",
  surname: "PRIVATE Surname",
  inst: "uni-a",
  email: "PRIVATE@example.org",
  orcid: "0000-0002-1825-0097",
  footnote: "PRIVATE author note",
)

#for (i, version) in ("preprint", "submission", "final").enumerate() {
  for (j, override) in (
    (:),
    (anonymous: auto),
    (anonymous: true),
    (anonymous: false),
  ).enumerate() {
    if i > 0 or j > 0 { pagebreak() }
    let option = override.at("anonymous", default: auto)
    let anonymous = if option == auto { version == "submission" } else {
      option
    }
    iacrj(
      ..(
        journal: "cic",
        version: version,
        title: "An anonymity test",
        authors: (author,),
        affiliations: (uni-a: "PRIVATE University"),
        running: (authors: "PRIVATE running authors"),
        license: "CC-BY-4.0",
      )
        + override,
    )[
      #metadata(anonymous) <anonymous-case>
      #context {
        assert.eq(
          document.author,
          if anonymous { ("hidden for submission",) } else { (author.name,) },
        )
        // Anonymity and review line numbering are independent.
        assert.eq(par.line.numbering != none, version == "submission")
      }
      First body page.
      #pagebreak()
      Second body page.
      #pagebreak()
      Third body page.
    ]
  }
}

#context {
  let rendered = query(metadata).filter(it => (
    type(it.value) == dictionary and "rendered-text" in it.value
  ))
  let on-pages(items, first) = items.filter(it => (
    first <= it.location().page() and it.location().page() < first + 3
  ))
  for case in query(<anonymous-case>) {
    let first = case.location().page()
    let anonymous = case.value
    let texts = on-pages(rendered, first).map(it => it.value.rendered-text)
    assert.eq(texts.any(text => text.contains("PRIVATE")), not anonymous)

    let meta = on-pages(query(<iacrj-meta>), first).first().value
    assert.eq(meta.authors.len(), if anonymous { 0 } else { 1 })
    assert.eq(meta.affiliations.len(), if anonymous { 0 } else { 1 })
    if not anonymous {
      assert.eq(meta.authors.first().name, author.name)
      assert.eq(meta.affiliations.uni-a.name, "PRIVATE University")
    }

    assert.eq(on-pages(query(footnote), first).len(), if anonymous { 0 } else {
      2
    })
    let orcid-links = on-pages(query(link), first).filter(it => (
      type(it.dest) == str and it.dest.starts-with("https://orcid.org/")
    ))
    assert.eq(orcid-links.len(), if anonymous { 0 } else { 1 })

    let author-page = if calc.even(first) { first + 1 } else { first + 2 }
    let header-texts = rendered
      .filter(it => it.location().page() == author-page)
      .map(it => it.value.rendered-text)
    assert(header-texts.contains(if anonymous {
      "Anonymous Submission to IACR Communications in Cryptology"
    } else { "PRIVATE running authors" }))
  }
}
