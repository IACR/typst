#import "/src/iacrj.typ": iacrj

// check.py compiles this fixture with each override and checks the diagnostic.
#let cases = (
  valid: [A reference to @single.],
  list: [#set list(indent: 1pt)
    Changed list style.],
  enum: [#set enum(indent: 1pt)
    Changed enumeration style.],
  heading: [#set heading(numbering: "I")
    Changed heading style.],
  figure: [#set figure(gap: 1pt)
    Changed figure style.],
  footnote: [#set footnote.entry(indent: 1pt)
    Changed footnote style.],
  bibliography: [#set bibliography(style: "apa")
    Changed bibliography style.],
  cite: [#set cite(style: "apa")
    Changed citation style.],
  explicit-cite: [#cite(<single>, style: "apa")],
  equation-above: [#show math.equation.where(block: true): set block(above: 0pt)
    $ x = y $],
  equation-below: [#show math.equation.where(block: true): set block(below: 0pt)
    $ x = y $],
  manual-bibliography: [#bibliography("/tests/bibliography-single/works.bib")],
  explicit-bibliography: [#bibliography(
    "/tests/bibliography-single/works.bib",
    style: "apa",
  )],
)

#show: iacrj.with(
  journal: "cic",
  title: "Style checks",
  authors: ("Alice",),
  bibliography: if sys.inputs.at("sources", default: "true") == "true" {
    "/tests/bibliography-single/works.bib"
  } else { () },
  enable-checks: sys.inputs.at("checks", default: "true") == "true",
)

#cases.at(sys.inputs.at("case", default: "valid"))
