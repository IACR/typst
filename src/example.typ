// This will eventually be moved out of the src directory, but for
// convenience we leave it here for now while we develop iacrj.typ
#import "iacrj.typ": iacrj

#show: iacrj.with(
  title: "Typst Template",
  authors: (
    (
      name: "Josiah Carberry",
      email: "josiah@carberry.org",
      orcid: "0000-0002-1825-0097",
      footnote: "This is a footnote for Josiah",
      inst: 1
    ),
    (
      name: "Truman Grayson",
      inst: (1,2)
    ),
    (
      name: "F.D.C. Willard",
      surname: "Willard",
      footnote: "Deceased 1982",
      inst: 2
    )
  ),
  affiliations: (
    (
      name: "University of Second Choice",
      department: "Department of Redundancy Department",
      city: "Hogsmeade",
      country: "Elbonia"
    ),
    ( name: "Vermont State University",
      city: "Castleton",
      country: "USA"
    )
  ),
  abstract: read("abstract.typ"),
  enable-checks: true,
)

// #set par.line(numbering: "1")

#heading("Introduction", numbering: none)

This is a sample document showing the Typst port of the iacrj template. It sets styling and gives the author a warning when changed, see @illegal for examples.

#{
  for i in ("Technical overview", "Preliminaries", "Lower bounds") {
    heading(i)
    lorem(140)
    parbreak()
    lorem(140)
  }
}

== Illegal actions <illegal>
Some actions might be blocked

// #set text(24pt)
// #set page("us-letter")
// #text(24pt)[Test]

// #import "@preview/hydra:0.6.3": hydra

// #set page(header: context {
//   if calc.odd(here().page()) {
//     align(right, emph(hydra(1)))
//   } else {
//     align(left, emph(hydra(2)))
//   }
//   line(length: 100%)
// })

== Lists/enumerates
We can have lists:
- With different
- bullet points
and
+ `enums`
+ that include numbers


== Monospace
Some monospace code:

```python
print("Some monospace code")
```

== Figures
We can have figures 
#figure(box("Box", stroke: 1pt, inset: 1em),
caption: "Caption of a box")