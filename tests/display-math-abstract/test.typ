// Check equation spacing in the abstract and body, without affecting inline math.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Display math",
  authors: ("Alice",),
  abstract: ```typ
    #show math.equation: it => context {
      assert(it.block, message: "The regression must exercise display math.")
      assert.eq(text.size, 9pt)
      assert.eq(block.above, 1em)
      assert.eq(block.below, 1em)
      it
    }

    Before the display equation.
    $ sum_(i=1)^n x_i^2 / 2 $
    After the display equation.
  ```.text,
)

#show math.equation: it => context {
  assert.eq(text.size, 10pt)
  assert.eq(block.above, if it.block { 1em } else { auto })
  assert.eq(block.below, if it.block { 1em } else { auto })
  it
}

Body with inline math $x + y$.
$ sum_(i=1)^n x_i^2 / 2 $
After the display equation.
