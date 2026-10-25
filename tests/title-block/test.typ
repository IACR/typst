// The public renderer works without journal metadata or the iacrj wrapper.
#import "/src/iacrj.typ": title-block, config

#set text(..config.text)
#set par(..config.par)

#let authors = (
  (name: "Alice", inst: (1,), email: "alice@example.org", footnote: "Author note.", orcid: "0000-0002-1825-0097"),
  (name: "Bob", inst: (2,), email: none, footnote: none, orcid: none),
)
#let affiliations = (
  (name: "University A", department: none, city: "City A", country: none),
  (name: "University B", department: none, city: "City B", country: none),
)

#title-block(
  title: "Standalone title block",
  authors: authors,
  affiliations: affiliations,
  abstract: [
    #show math.equation: it => context {
      assert(it.block)
      assert.eq(block.above, auto)
      assert.eq(block.below, auto)
      it
    }
    An abstract with display math.
    $ sum_(i=1)^n i $
  ],
  keywords: ("cryptography", "Typst"),
)

#context {
  assert.eq(text.size, config.text.size)
  assert.eq(par.justify, config.par.justify)
  assert.eq(par.first-line-indent, config.par.first-line-indent)
  assert.eq(block.above, auto)
  assert.eq(block.below, auto)
  assert.eq(counter(footnote).get(), (0,))
}

Body.#footnote[The body footnote starts at 1.]
#context assert.eq(counter(footnote).get(), (1,))

#pagebreak()
#title-block(
  title: "Anonymous title block",
  authors: (),
  affiliations: affiliations,
)

#context assert.eq(counter(footnote).get(), (0,))
