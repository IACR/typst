// Compile from the repository root; Typst uses src/ as the project root:
//   typst compile src/example.typ
//   typst compile --input version=submission src/example.typ
//   typst compile --input version=final src/example.typ
// For a final-version DOI/Crossmark header, the publisher also supplies the
// `iacrmetadata` compiler input described in README.md, not template arguments.
#import "iacrj.typ": iacrj

// Keep this show rule at the top level: all following content must be inside
// the template so its formatting, checks, and paper-length boundary apply.
#show: iacrj.with(
  journal: sys.inputs.at("journal", default: "cic"), // also "tosc" or "tches"
  version: sys.inputs.at("version", default: "preprint"), // or "submission", "final"
  // Set true only for submissions whose call for papers permits named authors.
  notanonymous: false,
  title: (
    full: "A Typst Template for IACR Journal Articles",
    short: "IACR Journal Template",
  ),
  authors: (
    (
      name: "Josiah Carberry",
      surname: "Carberry",
      email: "josiah@carberry.org",
      orcid: "0000-0002-1825-0097",
      footnote: "This is a footnote for Josiah.",
      inst: "uni-a",
    ),
    (
      name: "Truman Grayson",
      surname: "Grayson",
      inst: ("uni-a", "uni-b"),
    ),
    (
      name: "F.D.C. Willard",
      surname: "Willard",
      footnote: "Deceased 1982.",
      inst: "uni-b",
    ),
  ),
  // Dictionary insertion order determines numbering and display order.
  // A name-only affiliation can also be written as uni-a: "University A".
  affiliations: (
    uni-a: (
      name: "University of Second Choice",
      department: "Department of Redundancy Department",
      city: "Hogsmeade",
      country: "Elbonia",
    ),
    uni-b: (
      name: "Vermont State University",
      city: "Castleton",
      country: "USA",
    ),
  ),
  // Preserve the abstract's source for publishing metadata, including math.
  abstract: read("abstract.typ"),
  keywords: ("cryptography", "Typst", "journal templates", "accessibility"),
  // Bibliography filenames are relative to the Typst project root (src/ here).
  // A single filename is accepted too. The strings and entries below are read
  // together so journal aliases defined in the first file work in the second.
  bibliography: ("example-strings.bib", "example.bib"),
  // An SPDX identifier of a Creative Commons license; required for "final".
  license: "CC-BY-ND-4.0",
  // Temporarily set false only when style checks obstruct development.
  // Restore true before submission; metadata validation remains active.
  enable-checks: true,
)

#heading("Introduction", numbering: none)

This sample demonstrates the Typst template for the IACR journals CiC, ToSC,
and TCHES.#footnote[The first body footnote is numbered 1, independently of the author notes.]
The document title, abstract heading, section headings, and reference list use
native Typst elements rather than visually styled substitutes.

= Front matter and versions

The title has a full form for the first page and a shorter form for running
headers. Authors refer to affiliations by short keys; the keys are not printed.
The displayed superscript numbers link to the corresponding institutions, and
multiple keys associate an author with multiple affiliations. ORCID icons link
to the named author's record. Email addresses appear in an unnumbered footnote,
followed by lettered author notes.

The default version is a preprint. With `--input version=submission`, the example
hides names, affiliations, emails, ORCID links, and author notes from the front
matter, running headers, PDF author metadata, and the queried metadata. Authors must
still avoid identifying themselves in the paper's prose and abstract.

With `--input version=final`, publisher-supplied journal metadata controls the
first-page publication header. CiC shows the DOI URL and, when a Crossmark date
is provided, the linked “Check for updates” badge. ToSC and TCHES show a DOI on
the issue line without the badge. Publication links are omitted from preprints
and submissions. The Crossmark URL is derived from the DOI and the validated
publication date, not supplied separately by the author.

= Citations and references

Public-key cryptography has a long history: see Diffie and Hellman @DH76 and
Rivest, Shamir, and Adleman @RSA78. An explicit citation works too:
#cite(<RSA78>, supplement: [Section 3]).

The template supplies matching alphanumeric labels in citations and the
reference list, approximating the LaTeX class's `alphaurl` style. The two BibTeX
files in this example demonstrate journal-name aliases defined separately from
the entries that use them. Both files are concatenated before parsing.

Do not call `bibliography(...)` yourself: the template appends the reference
list automatically, and the filenames must be available to the publishing
pipeline through the `bibliography:` option.

= Mathematics and accessibility

Describe mathematical content with alternative text so assistive technology
can announce it. For example, let
#math.equation(alt: "n is a positive integer", $n in ZZ_(>0)$). The sum of the
first #math.equation(alt: "n", $n$) positive integers is

#math.equation(
  block: true,
  alt: "The sum of i from one to n equals n times n plus one, divided by two.",
  $sum_(i=1)^n i = (n(n + 1)) / 2.$,
)

The abstract also contains display mathematics. It remains in normal document
flow, so longer abstracts can span pages without changing equation spacing.

== Lists and code

Use native lists for structured content:
- Supply structured author and affiliation metadata.
- Give meaningful images and equations alternative descriptions.
- Use real headings, figures, and tables to retain their semantics.

A typical publishing workflow is:
+ Prepare the preprint and check all citations.
+ Compile the anonymous submission and inspect it for identifying prose.
+ Let the publisher supply publication metadata for the final version.

Use native raw blocks for code, with the template's monospaced font:

```python
def triangular_number(n):
    return n * (n + 1) // 2
```

== Figures and tables

#figure(
  alt: "A box containing the words Example diagram.",
  box("Example diagram", stroke: 1pt, inset: 1em),
  caption: [An illustrative diagram with a meaningful alternative description.],
) <example-figure>

#figure(
  table(
    columns: 2,
    align: left,
    table.header([*Version*], [*Author information*]),
    [Preprint], [Visible],
    [Submission], [Hidden unless explicitly permitted],
    [Final], [Visible],
  ),
  caption: [Document versions and their handling of author information.],
) <example-table>

@example-figure and @example-table demonstrate the different caption positions:
figure captions appear below their content, while table captions appear above.
The table uses `table.header` so its column headings are identified semantically.

= Formatting checks and publishing metadata <publishing>

The template owns the journal's page geometry, fonts, spacing, and citation
style. Direct overrides are rejected by its style checks. For example, the
following are examples of what *not* to add to a paper:

```typ
#set text(size: 24pt)
#set page("us-letter")
#set bibliography(style: "apa")
#cite(<RSA78>, style: "apa")
#bibliography("references.bib")
```

The template automatically performs checks against the style guide. If the
checks obstruct development or debugging, temporarily set `enable-checks: false`
in the `iacrj.with(...)` options. This disables style checks, not the template's
default formatting or metadata validation. Manual bibliography calls remain
prohibited; use the `bibliography:` option instead. Restore `enable-checks:
true` (the default) before submission.

The paper's metadata can be queried as JSON from the repository root:

```sh
typst query src/example.typ '<iacrj-meta>' --field value --one
```

It records the bibliography filenames, the abstract's original source, and
`pages`: the physical page count through the end of the paper, including front
matter but excluding bibliography-only pages. A page shared by the paper and
its references still counts as a paper page. The BibTeX files themselves are
not included; their delivery to the publisher is still to be determined.
