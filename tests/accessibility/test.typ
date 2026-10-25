// Keep semantic elements even when their visual appearance is customized.
// Also compile this fixture with --pdf-standard ua-1,a-2a.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Accessible template",
  authors: (
    (
      name: "Alice",
      email: "alice@example.org",
      orcid: "0000-0002-1825-0097",
      footnote: "An author note.",
    ),
  ),
  affiliations: ("University A",),
  abstract: "An abstract with semantic structure.",
  keywords: ("accessibility", "cryptography"),
)

= Introduction

Body text with a footnote.#footnote[A body note.]

- A bulleted item.
- Another item.

+ A numbered item.
+ Another item.

== Details

#math.equation(block: true, alt: "a plus b equals c", $a + b = c$)

#figure(
  rect(width: 30pt, height: 20pt),
  alt: "A rectangular outline",
  caption: [A sample diagram.],
)

#figure(
  table(
    columns: 2,
    table.header([Item], [Value]),
    [A], [1],
  ),
  caption: [A sample table.],
)

#context {
  assert.eq(query(std.title).map(it => it.body), ([Accessible template],))
  let headings = query(heading)
  assert.eq(headings.map(it => it.body), (
    [Abstract],
    [Introduction],
    [Details],
  ))
  assert.eq(headings.first().numbering, none)
  assert.eq(headings.first().outlined, false)
  assert.eq(counter(heading).at(headings.at(1).location()), (1,))
  assert.eq(counter(heading).at(headings.at(2).location()), (1, 1))
  assert.eq(document.title, [Accessible template])
  assert.eq(document.author, ("Alice",))
  assert.eq(document.keywords, ("accessibility", "cryptography"))
  assert.eq(query(image).map(it => it.alt), ("ORCID record for Alice",))
  assert.eq(query(footnote).len(), 3) // Email, author note, body note.
  assert.eq(query(figure.caption).len(), 2)
}
