// ORCID icons follow a plain name, affiliation marks, or author-footnote marks.
// The visual reference checks their cap-height sizing, baseline and left margin.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "ORCID in Front Matter",
  authors: (
    (name: "Alice", orcid: "0000-0002-1825-0097"),
    (name: "Bob", inst: "uni-a", orcid: "0000-0002-9079-593X"),
    (
      name: "Carol",
      inst: "uni-b",
      orcid: "0000-0003-1010-8157",
      footnote: "An author note for Carol.",
    ),
    (name: "Dave", inst: "uni-b"),
  ),
  affiliations: (uni-a: "University A", uni-b: "University B"),
)

#context {
  let links = query(link).filter(it => (
    type(it.dest) == str and it.dest.starts-with("https://orcid.org/")
  ))
  assert.eq(links.map(it => it.dest), (
    "https://orcid.org/0000-0002-1825-0097",
    "https://orcid.org/0000-0002-9079-593X",
    "https://orcid.org/0000-0003-1010-8157",
  ))
  assert.eq(counter(footnote).get(), (0,))
}

Body text.#footnote[The first body footnote.]
#context assert.eq(counter(footnote).get(), (1,))
