// The public header renderer works independently of the iacrj wrapper.
#import "/src/iacrj.typ": page-header, config

#set text(..config.text)
#set par(..config.par)
#set page(..config.page, header: page-header(
  config.journals.cic,
  title: "Standalone short title",
  authors: ((name: "Alice"), (name: "Bob")),
  version: "final",
  volume: 5,
  number: 3,
))

// Record rendered header text, including content produced inside context blocks.
#show regex("Alice, Bob|Standalone short title|Anonymous Submission to IACR Communications in Cryptology|Vol\\.\u{a0}5|No\\.\u{a0}3"): it => {
  metadata(it.text)
  it
}

First-page journal header.
#pagebreak()
Even-page title header.
#pagebreak()
Odd-page author header.

#pagebreak()
#set page(header: page-header(config.journals.cic, title: "Standalone short title"))
Even-page anonymous title header.
#pagebreak()
Odd-page anonymous journal header.

#context {
  let rendered = query(metadata).map(it => it.value)
  assert(rendered.contains("Alice, Bob"))
  assert(rendered.contains("Standalone short title"))
  assert(rendered.contains("Anonymous Submission to IACR Communications in Cryptology"))
  assert(rendered.contains("Vol.\u{a0}5"))
  assert(rendered.contains("No.\u{a0}3"))
  assert.eq(text.size, config.text.size)
  assert.eq(par.leading, config.par.leading)
}
