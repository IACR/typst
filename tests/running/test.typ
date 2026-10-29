// Running-head defaults, overrides, abbreviation, and anonymous submissions.
#import "/src/iacrj.typ": _running-authors, iacrj

#let short-authors = (
  (name: "Alice Example", surname: "Example"),
  (name: "Bob Example"),
)
#let long-authors = (
  (name: "Alice van Example", surname: "van Example"),
  (name: "Bob With A Particularly Long Name"),
  (name: "Carol With Another Particularly Long Name"),
)

#assert.eq(_running-authors(()), none)
#assert.eq(_running-authors(short-authors), "Alice Example, Bob Example")
// Many short names still fit; even two long names can require abbreviation.
#assert.eq(
  _running-authors(("A", "B", "C", "D", "E").map(name => (name: name))),
  "A, B, C, D, E",
)
#assert.eq(_running-authors(long-authors), "van Example et al.")
#assert.eq(
  _running-authors((
    (name: "Alice van Example"),
    long-authors.at(1),
    long-authors.at(2),
  )),
  "Example et al.",
)
#let long-name = "A" * 34
#assert.eq(
  _running-authors(((name: long-name), (name: "B" * 34))),
  long-name + ", " + "B" * 34,
)
#assert.eq(
  _running-authors(((name: long-name, surname: "Example"), (name: "B" * 35))),
  "Example et al.",
)
// A single author must not become "et al.", even with a long name.
#assert.eq(_running-authors(((name: "A" * 80),)), "A" * 80)

#let error(running) = catch(() => iacrj(
  journal: "cic",
  title: "Full Title",
  authors: short-authors,
  running: running,
)[Body])
#for running in (
  1,
  "Title",
  (titel: "Title"),
  (title: 1),
  (authors: ("Alice",)),
) {
  assert(error(running).contains("iacrj.running"))
}

// Record rendered text so the assertions exercise deferred header rendering,
// not just content equality (context blocks can compare equal).
#show regex(".+"): it => {
  metadata((running-text: it.text))
  it
}

#let cases = (
  (
    options: (:),
    title: "Short Title",
    authors: "Alice Example, Bob Example",
  ),
  (
    options: (running: (title: auto, authors: auto)),
    title: "Short Title",
    authors: "Alice Example, Bob Example",
  ),
  (
    options: (running: (title: "RUNNING TITLE", authors: "RUNNING AUTHORS")),
    title: "RUNNING TITLE",
    authors: "RUNNING AUTHORS",
  ),
  (
    options: (running: (title: "RUNNING TITLE")),
    title: "RUNNING TITLE",
    authors: "Alice Example, Bob Example",
  ),
  (
    options: (title: "Full Title", running: (authors: "RUNNING AUTHORS")),
    title: "Full Title",
    authors: "RUNNING AUTHORS",
  ),
  (
    options: (authors: long-authors),
    title: "Short Title",
    authors: "van Example et al.",
  ),
  (
    options: (
      version: "submission",
      running: (title: "RUNNING TITLE", authors: "RUNNING AUTHORS"),
    ),
    title: "RUNNING TITLE",
    authors: "Anonymous Submission to IACR Communications in Cryptology",
  ),
  (
    options: (
      version: "submission",
      anonymous: false,
      running: (authors: "RUNNING AUTHORS"),
    ),
    title: "Short Title",
    authors: "RUNNING AUTHORS",
  ),
)

#for (i, case) in cases.enumerate() {
  if i > 0 { pagebreak() }
  iacrj(
    ..(
      journal: "cic",
      title: (full: "Full Title", short: "Short Title"),
      authors: short-authors,
    )
      + case.options,
  )[
    #metadata((title: case.title, authors: case.authors)) <running-case>
    First body page.
    #pagebreak()
    Second body page.
    #pagebreak()
    Third body page.
  ]
}

#context {
  let rendered = query(metadata).filter(it => (
    type(it.value) == dictionary and "running-text" in it.value
  ))
  for case in query(<running-case>) {
    let first-page = case.location().page()
    for page in range(first-page + 1, first-page + 3) {
      let texts = rendered
        .filter(it => it.location().page() == page)
        .map(it => it.value.running-text)
      let expected = if calc.even(page) { case.value.title } else {
        case.value.authors
      }
      assert(
        texts.contains(expected),
        message: "Missing running head: " + expected,
      )
      if case.value.authors.starts-with("Anonymous") {
        assert(not texts.contains("RUNNING AUTHORS"))
      }
    }
  }
  // Running-head overrides must not change the paper's publishing metadata.
  for meta in query(<iacrj-meta>).map(it => it.value) {
    assert.eq(meta.title.full, "Full Title")
    if meta.authors.len() > 0 {
      assert(meta.authors.first().name.starts-with("Alice"))
    }
  }
}
