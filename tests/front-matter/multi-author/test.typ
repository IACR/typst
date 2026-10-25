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
      inst: 1,
      email: "josiah@carberry.org",
      orcid: "0000-0002-1825-0097",
      footnote: "Footnote for Josiah",
    ),
    (name: "Truman Grayson", inst: (1, 2)),
    (name: "F.D.C. Willard", inst: 2, footnote: "Deceased 1982"),
  ),
  affiliations: (
    (
      name: "University of Second Choice",
      department: "Department of Redundancy Department",
      city: "Hogsmeade",
      country: "Elbonia",
    ),
    (name: "Vermont State University", city: "Castleton", country: "USA"),
  ),
  keywords: ("typst", "templates"),
)

Body text with a footnote.#footnote[The first body footnote.]
