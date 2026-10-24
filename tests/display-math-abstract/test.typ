// Check spacing at the display equation, not merely elsewhere in the abstract.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Display math",
  authors: ("Alice",),
  abstract: ```typ
    #show math.equation: it => context {
      assert(it.block, message: "The regression must exercise display math.")
      assert.eq(block.above, auto)
      assert.eq(block.below, auto)
      it
    }

    Before the display equation.
    $ sum_(i=1)^n x_i^2 / 2 $
    After the display equation.
  ```.text,
)

Body.
