// Several authors and affiliations: numbered affiliation marks, lettered
// author footnotes after them, ORCID icon last, and the email footnote listed
// first. Body footnotes start again at 1.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "Multi-Author Paper",
  authors: (
    (
      name: "Josiah Carberry",
      inst: "uni-a",
      email: "josiah@carberry.org",
      orcid: "0000-0002-1825-0097",
      footnote: "Footnote for Josiah",
    ),
    (name: "Truman Grayson", inst: ("uni-a", "uni-b")),
    (name: "F.D.C. Willard", inst: "uni-b", footnote: "Deceased 1982"),
  ),
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
  keywords: ("typst", "templates"),
)

Body text with a footnote.#footnote[The first body footnote.]
