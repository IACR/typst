#import "@preview/valkyrie:0.2.2" as z
#import "@preview/ccicons:1.0.1": ccicon

// Fonts. New Computer Modern is bundled with Typst; the sans and mono
// variants (closest to Latin Modern Sans/Mono) must be installed.
#let serif = "new computer modern"
#let sans = "new computer modern sans"
#let mono = ("new computer modern mono", "dejavu sans mono")

// TODO: review AI generated spacing and values.
#let config = (
  // geometry: a4paper, hscale=0.65, vscale=0.75, marginratio=1:1
  //   text width  = 0.65 * 210mm = 136.5mm  -> 36.75mm left and right
  //   text height = 0.75 * 297mm = 222.75mm -> 37.125mm top and bottom
  // The extra 3pt at the top puts the first baseline 10pt below the top of
  // the text block (\topskip), as in LaTeX.
  page: (
    width: 210mm,
    height: 297mm,
    margin: (
      top: 37.125mm + 3pt,
      bottom: 37.125mm,
      left: 36.75mm,
      right: 36.75mm,
    ),
    numbering: "1",
    header-ascent: 31.5pt, // header baseline 28.5pt above the text block
    footer: none,
  ),
  // Name and ISSN of each journal (\publname and \IACR@EISSN).
  journals: (
    cic: (name: "IACR Communications in Cryptology", issn: "3006-5496"),
    tosc: (
      name: "IACR Transactions on Symmetric Cryptology",
      issn: "2519-173X",
    ),
    tches: (
      name: "IACR Transactions on Cryptographic Hardware and Embedded Systems",
      issn: "2569-2925",
    ),
  ),
  // First-page header (fancypagestyle title): \small, 9pt on 11pt.
  // Its two lines don't fit in \headheight (12pt), so fancyhdr enlarges it
  // to 20.5pt, which moves the header 8.5pt down towards the text.
  first-page-header: (
    text: (size: 9pt),
    leading: 4.7pt,
    dy: 8.5pt,
    updates-gap: 2pt,
  ),
  // First-page footer (fancypagestyle title): \small, 9pt on 11pt, plus the
  // .1em after the license line. The first baseline is \footskip (30pt)
  // below the text block; CiC's taller badge pushes the footer down a line.
  // The badge is 4em wide (doclicense imagewidth=4em).
  first-page-footer: (
    text: (size: 9pt),
    leading: 5.6pt,
    first-baseline: (cic: 41.9pt, other: 30pt),
    image: (format: "badge", height: 1.4em),
  ),
  // Rule under the running head, across the text width (pages 2+).
  // `gap` is the distance below the header baseline.
  header-rule: (stroke: 0.4pt, gap: 5pt),
  // \documentclass[10pt]{article}: 10pt on 12pt
  text: (
    size: 10pt,
    font: serif, // lowercase: Typst normalizes font names
    lang: "en",
    top-edge: 0.7em,
    bottom-edge: 0em, // baseline-to-baseline = 0.7em + leading
  ),
  par: (
    justify: true,
    first-line-indent: (amount: 15pt, all: false),
    leading: 0.5em, // 12pt baselines
    // LaTeX paragraph spacing is variable to fill the entire page. Typst does not support this.
    // https://github.com/typst/typst/issues/6042
    spacing: 0.5em, // \parskip = 0pt
  ),

  // Approximate article.cls's regular display skips: 10pt in the body and
  // 9pt in the abstract (LaTeX uses 8.5pt). No short-line or stretch/shrink logic.
  equation: (above: 1em, below: 1em),

  // article.cls headings. CiC: serif bold; ToSC/TCHES: sans bold (sectsty).
  // TODO: check spacing
  heading: (
    numbering: "1.1",
    levels: (
      // \section, \Large: 33.3pt above / 22.0pt below (baseline to baseline)
      (
        text: (size: 14.4pt, weight: "bold"),
        block: (above: 23.2pt, below: 15pt),
      ),
      // \subsection, \large: 27.4pt / 18.4pt
      (text: (size: 12pt, weight: "bold"), block: (above: 19pt, below: 11.4pt)),
      // \subsubsection, \normalsize: 26.3pt / 18.4pt
      (
        text: (size: 10pt, weight: "bold"),
        block: (above: 19.3pt, below: 11.4pt),
      ),
    ),
  ),

  // itemize/enumerate: label at 12pt, text at 25pt (\leftmargini = 2.5em),
  // \itemsep + \parsep = 8.2pt between items and around the list.
  list: (
    indent: 12.1pt,
    body-indent: 5pt,
    spacing: 13.2pt,
    marker: ([•], [–], [∗], [·]),
  ),
  enum: (indent: 12.1pt, body-indent: 5pt, spacing: 13.2pt),
  list-block: (above: 13.2pt, below: 13.2pt),

  // \texttt: Latin Modern Mono at the text size (Typst scales raw to 0.8em).
  raw: (font: mono, size: 1.25em),

  // float package (iacrabove/iacrbelow): "Figure 1:" in sans bold,
  // table captions above the table.
  figure: (gap: 10pt),
  table-caption: (position: top),
  caption-label: (font: sans, weight: "bold"),

  // Submissions number their lines, like lineno with
  // \linenumberfont = \normalfont\tiny\sffamily\color{gray}.
  line-numbers: (size: 5pt, font: sans, fill: gray),

  // \footnotesize (8pt on 9.5pt), rule of 0.4\textwidth, text at 1.8em.
  footnote: (
    entry: (separator: line(length: 40%, stroke: 0.4pt), indent: 18pt),
    text: (size: 8pt),
    par: (leading: 3.9pt),
  ),

  // Use one style for citations and their reference-list labels. The built-in
  // alphanumeric style supports citations only, so a small CSL defines both.
  bibliography: (style: read("iacrj.csl", encoding: none)),
  cite: (style: auto),

  // hyperref colorlinks of journal=cic, used for all journals (iacrj.cls
  // leaves ToSC and TCHES URLs in hyperref's default magenta).
  colors: (
    url: rgb(0, 0, 255), // urlcolor=blue
    link: rgb(77, 0, 0), // linkcolor=black!70!red
    cite: rgb(0, 77, 0), // citecolor=black!70!green
  ),

  // \maketitle of metacapture (maketitle=iacrj), abstract and keywords.
  // `gap` controls stack spacing or the space above a flow block.
  // Values approximate the baselines of iacrj-doc.pdf.
  title-block: (
    // \LARGE\bfseries\sffamily: 17.28pt on 22pt
    title: (
      gap: 36.8pt,
      text: (size: 17.28pt, font: sans, weight: "bold"),
      leading: 9.9pt,
    ),
    // \large\sffamily\bfseries
    subtitle: (gap: 15.1pt, text: (size: 12pt, font: sans, weight: "bold")),
    // \large: 12pt on 14.5pt
    authors: (
      gap: 19.4pt,
      text: (size: 12pt),
      leading: 6.1pt,
      mark-raise: -0.37em,
    ),
    // \small: 9pt on 11pt
    affiliations: (
      gap: 16.4pt,
      text: (size: 9pt),
      leading: 4.7pt,
      mark-raise: -0.42em,
    ),
    // superscript affiliation numbers (\scriptsize relative to the line)
    marks: (typographic: false, size: 0.667em),
    // article abstract: \small, quotation margins 2.5em, indent 1.5em
    abstract: (
      gap: 29.8pt,
      heading-gap: 9.3pt,
      text: (size: 9pt),
      par: (
        leading: 4.7pt,
        spacing: 4.7pt,
        justify: true,
        first-line-indent: (amount: 1.5em, all: false),
      ),
      margin: 25pt,
    ),
    // \textbf{\textsf{Keywords:}}~
    keywords: (gap: 12.2pt, label: (font: sans, weight: "bold")),
  ),
)

// Downloaded from https://info.orcid.org/documentation/integration-guide/orcid-id-display-guidelines/
#let _orcid-icon = image.with(
  read("icons/orcid.svg", encoding: none),
  alt: "ORCID iD",
  format: "svg",
)

#let _checksum_valid(id) = {
  // ISO 7064 MOD 11-2 check digit over the first 15 digits.
  let total = id
    .slice(0, 15)
    .clusters()
    .map(int)
    .fold(0, (acc, d) => (acc + d) * 2)
  let check = calc.rem(12 - calc.rem(total, 11), 11)
  let expected = if check == 10 { "X" } else { str(check) }
  return id.last() == expected
}

/// ORCID iD icon linking to the author's ORCID record, like `\OrcidLink` in
/// metacapture.sty (used by iacrj.cls): the "authenticated" logo, sitting on
/// the baseline with a 0.2em gap after the author name and affiliation marks.
/// The default height matches the cap height of the 12pt New Computer Modern authors.
/// `alt` describes the linked record to assistive technology.
///
/// Accepts e.g. "0000-0002-1825-0097", "0000 0002 1825 0097",
/// "0000000218250097", "https://orcid.org/0000-0002-1825-0097",
/// "orcid.org/0000-0002-1825-009x". Panics on malformed IDs and wrong checksums.
#let orcid(id, height: 8.2pt, hor-margin: 0.2em, alt: "ORCID iD") = {
  assert(
    type(id) == str,
    message: "orcid: expected a string like \"0000-0002-1825-0097\", got "
      + repr(type(id)),
  )

  // Normalize: drop URL prefix, spaces and hyphens; uppercase the check digit.
  let id = upper(
    id
      .trim()
      .replace(regex("^(?i)(https?://)?(www\.)?orcid\.org/"), "")
      .replace(regex("[\s-]"), ""),
  )
  if id.match(regex("^\d{15}[\dX]$")) == none {
    panic(
      "orcid: \""
        + id
        + "\" is not a valid ORCID. Expected 16 characters like 0000-0002-1825-0097 (the last one may be X).",
    )
  }

  if not _checksum_valid(id) {
    panic(
      "orcid: \""
        + id
        + "\" has an invalid checksum. Check the ORCID for typos.",
    )
  }

  let formatted = range(4).map(i => id.slice(i * 4, i * 4 + 4)).join("-")

  // metacapture uses a 0.2em gap in other author layouts; keep the spacing
  // here rather than relying on a literal space at each call site.
  link("https://orcid.org/" + formatted, box(
    inset: (left: hor-margin),
    _orcid-icon(height: height, alt: alt),
  ))
}

#let _crossmark-icon = read("icons/crossmark.svg", encoding: none)

// Sanity-check a yyyy-mm-dd date string.
#let _validate-date(value, key: "crossmark-date") = {
  if (
    type(value) != str or value.match(regex("^\\d{4}-\\d{2}-\\d{2}$")) == none
  ) {
    panic(
      "iacrj: invalid "
        + key
        + "; expected YYYY-MM-DD, got "
        + repr(value)
        + ".",
    )
  }
  let (year, month, day) = value.split("-").map(int)
  datetime(year: year, month: month, day: day).display("[year]-[month]-[day]")
}

#let _crossmark-url(doi, date-stamp) = {
  let date-stamp = _validate-date(date-stamp)
  // Encode the DOI as one query parameter, including any reserved characters.
  let data = bytes(doi)
  let encoded = range(data.len())
    .map(i => {
      let byte = data.at(i)
      let char = str.from-unicode(byte)
      if (
        char
          in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
      ) {
        char
      } else {
        let hex = upper(str(byte, base: 16))
        "%" + if hex.len() == 1 { "0" + hex } else { hex }
      }
    })
    .join()
  (
    "https://crossmark.crossref.org/dialog/?doi="
      + encoded
      + "&domain=pdf&date_stamp="
      + date-stamp
  )
}

/// Render the linked Crossmark badge for a DOI and its PDF major-version date.
#let check-for-updates(doi, date-stamp, width: 69pt) = {
  link(_crossmark-url(doi, date-stamp), image(
    _crossmark-icon,
    width: width,
    alt: "Check for updates",
    format: "svg",
  ))
}

/// Parses the journal metadata that the publisher supplies for the final
/// version (\jobname.iacrmetadata in iacrj.cls): one `key=value` per line,
/// e.g. "date-received=2026-03-01\ndate-accepted=2026-08-01". A supplied
/// file must have `date-received` and `date-accepted`; `none` means no file.
/// Optional `doi` and `crossmark-date` fields supply final-version links; the
/// date identifies the PDF's last major version. Blank lines and unknown keys
/// are ignored, so the publisher can add keys before the template uses them.
/// Values are unquoted and each key may appear only once.
#let _parse-iacrmetadata(text) = {
  let supplied = text != none
  let text = if supplied { text } else { "" }
  let values = (:)
  for line in text.split("\n").map(str.trim).filter(line => line != "") {
    let parts = line.split("=")
    if parts.len() < 2 {
      panic(
        "iacrj: iacrmetadata line \""
          + line
          + "\" is not of the form key=value.",
      )
    }
    let key = parts.first().trim()
    let value = parts.slice(1).join("=").trim()
    if key in values {
      panic("iacrj: iacrmetadata key " + key + " appears more than once.")
    }
    // A quoted value would put the quotes into the header and the DOI links.
    if value.match(regex("^[\"'`]|[\"'`]$")) != none {
      panic(
        "iacrj: iacrmetadata "
          + key
          + " must not be quoted, got "
          + value
          + ".",
      )
    }
    values.insert(key, value)
  }

  let integer(key) = {
    let value = values.at(key, default: none)
    if value == none { return none }
    if value.match(regex("^\d+$")) == none {
      panic(
        "iacrj: iacrmetadata "
          + key
          + " must be a whole number, got \""
          + value
          + "\".",
      )
    }
    int(value)
  }
  let optional(key) = {
    let value = values.at(key, default: none)
    if value == "" { none } else { value }
  }
  let doi = optional("doi")
  // A DOI name is "10.<registrant>/<suffix>"; the suffix may contain "/" and
  // "=", but no whitespace.
  if doi != none and doi.match(regex("^10\.\d{4,9}/\S+$")) == none {
    panic(
      "iacrj: iacrmetadata doi must be a DOI such as 10.62056/a66c0l2hd, "
        + "not its https://doi.org/ URL; got \""
        + doi
        + "\".",
    )
  }
  let date(key) = {
    let value = optional(key)
    if value != none { _validate-date(value, key: key) }
  }
  let dates = (
    date-received: date("date-received"),
    date-accepted: date("date-accepted"),
    date-revised: date("date-revised"),
    date-final: date("date-final"),
  )
  // Received <= accepted <= final, and received <= revised <= final; the
  // revised date may come before or after acceptance. Validated YYYY-MM-DD
  // strings sort like the dates; a pair with a missing date is skipped.
  for (earlier, later) in (
    ("date-received", "date-accepted"),
    ("date-accepted", "date-final"),
    ("date-received", "date-final"),
    ("date-received", "date-revised"),
    ("date-revised", "date-final"),
  ) {
    if dates.at(earlier) == none or dates.at(later) == none { continue }
    if dates.at(earlier) > dates.at(later) {
      panic(
        "iacrj: iacrmetadata "
          + earlier
          + " ("
          + dates.at(earlier)
          + ") must not be after "
          + later
          + " ("
          + dates.at(later)
          + ").",
      )
    }
  }
  let result = (
    volume: integer("volume"),
    issue: integer("issue"),
    doi: doi,
    crossmark-date: date("crossmark-date"),
    ..dates,
  )
  // Checked last, so that a malformed value reports its own error first.
  let missing = ("date-received", "date-accepted").filter(key => (
    dates.at(key) == none
  ))
  if supplied and missing.len() > 0 {
    panic("iacrj: iacrmetadata must have " + missing.join(" and ") + ".")
  }
  result
}

// The supported licenses, keyed by SPDX identifier: the ccicons image, the
// doclicense short name and the Creative Commons deed.
#let _licenses = (
  "CC-BY-4.0": (icon: "cc-by", name: "CC BY 4.0", path: "licenses/by/4.0/"),
  "CC-BY-SA-4.0": (
    icon: "cc-by-sa",
    name: "CC BY-SA 4.0",
    path: "licenses/by-sa/4.0/",
  ),
  "CC-BY-ND-4.0": (
    icon: "cc-by-nd",
    name: "CC BY-ND 4.0",
    path: "licenses/by-nd/4.0/",
  ),
  "CC-BY-NC-4.0": (
    icon: "cc-by-nc",
    name: "CC BY-NC 4.0",
    path: "licenses/by-nc/4.0/",
  ),
  "CC-BY-NC-SA-4.0": (
    icon: "cc-by-nc-sa",
    name: "CC BY-NC-SA 4.0",
    path: "licenses/by-nc-sa/4.0/",
  ),
  "CC-BY-NC-ND-4.0": (
    icon: "cc-by-nc-nd",
    name: "CC BY-NC-ND 4.0",
    path: "licenses/by-nc-nd/4.0/",
  ),
  "CC0-1.0": (icon: "cc-zero", name: "CC0 1.0", path: "publicdomain/zero/1.0/"),
)

/// Render the first-page footer: the license with its image, then (final
/// version only) the received, revised, accepted and final-version dates,
/// spread across the line. `license` is an SPDX identifier from `_licenses`;
/// `dates` has the date-* fields of the iacrmetadata.
#let first-page-footer(journal, license, version: "preprint", dates: (:)) = {
  let cfg = config.first-page-footer
  let license = _licenses.at(license)
  let url = "https://creativecommons.org/" + license.path
  let img = cfg.image
  set text(..cfg.text)
  set par(leading: cfg.leading, justify: false, first-line-indent: 0pt)
  [This work is licensed under a #link(url)[“#license.name”] license.]
  h(1fr)
  // A zero-height box puts the image on the baseline without making the
  // line taller, so the first baseline stays where `first-baseline` says.
  box(width: 4em, place(bottom + left, link(url, {
    set image(alt: license.name + " license")
    ccicon(
      license.icon,
      format: img.format,
      scale: img.height / 0.75em,
      baseline: 0%,
    )
  })))
  if version != "final" { return }
  let entries = (
    ("Received", dates.at("date-received", default: none)),
    ("Revised", dates.at("date-revised", default: none)),
    ("Accepted", dates.at("date-accepted", default: none)),
    ("Final version", dates.at("date-final", default: none)),
  ).filter(e => e != none and e.last() != none)
  if entries.len() == 0 { return }
  linebreak()
  entries.map(((label, value)) => [#label: #value]).join(h(1fr))
}

/// Place the first-page footer in the bottom margin of the current page.
/// It is document content rather than the page footer: PDF/UA forbids links
/// in page artifacts, and the license statement should be read anyway.
#let place-first-page-footer(
  journal,
  license,
  version: "preprint",
  dates: (:),
) = {
  let cfg = config.first-page-footer
  let cic = journal.issn == config.journals.cic.issn
  let first-baseline = if cic { cfg.first-baseline.cic } else {
    cfg.first-baseline.other
  }
  // Measured from the top of the text block, since footnotes shrink the
  // flow at the bottom. The zero-height block's content hangs below that
  // point; its first line is as tall as the text's top edge.
  let (height, margin) = config.page
  let dy = (
    height
      - margin.top
      - margin.bottom
      + first-baseline
      - config.text.top-edge.em * cfg.text.size
  )
  place(top + left, dy: dy, block(width: 100%, height: 0pt, {
    first-page-footer(journal, license, version: version, dates: dates)
  }))
}

/// Render the publication header: journal, issue, DOI and Crossmark badge.
/// The caller decides whether this header should appear; page counts resolve
/// in context. `journal` is a dictionary with `name` and `issn`.
#let first-page-header(
  journal,
  volume: none,
  issue: none,
  doi: none,
  crossmark-date: none,
) = context {
  // Journal name and issue on the left, publication links on the right.
  set text(..config.first-page-header.text)
  set par(leading: config.first-page-header.leading)
  let pages = counter(page).final().first()
  let issue-line = (
    [ISSN~#journal.issn],
    if volume != none [Vol.~#volume],
    if issue != none [No.~#issue],
    [#pages~#if pages == 1 [page.] else [pages.]],
  ).filter(x => x != none)
  let cic = journal.issn == config.journals.cic.issn
  let journal-info = {
    journal.name
    linebreak()
    issue-line.join[, ]
  }
  let header = block(width: 100%, spacing: 0pt, {
    if cic and doi != none {
      grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        align: top,
        journal-info,
        {
          set align(right)
          link("https://doi.org/" + doi)
          if crossmark-date != none {
            linebreak()
            v(config.first-page-header.updates-gap)
            check-for-updates(doi, crossmark-date)
          }
        },
      )
    } else {
      journal-info
      if not cic and doi != none {
        h(1fr)
        link("https://doi.org/" + doi)[DOI: #doi]
      }
    }
  })
  move(dy: config.first-page-header.dy, header)
}

/// Render the first-page journal header and subsequent running heads.
/// `journal` is a dictionary with `name` and `issn`; authors are normalized
/// metadata dictionaries. An empty author list produces an anonymous running head.
/// DOI and Crossmark links appear only in the final version's first-page header.

#let page-header(
  journal,
  title: "",
  authors: (),
  version: "preprint",
  volume: none,
  issue: none,
  doi: none,
  crossmark-date: none,
) = {
  let author-running = if authors.len() == 0 {
    "Anonymous Submission to " + journal.name
  } else {
    authors.map(a => a.name).join(", ")
  }
  // All `context` blocks compare equal, so a user's `context` header would
  // pass the check. The metadata marker makes the template's header unique.
  metadata("iacrj-header")
  context {
    let n = counter(page).get().first()
    if here().page() == 1 {
      if version != "final" { return }
      first-page-header(
        journal,
        volume: volume,
        issue: issue,
        doi: doi,
        crossmark-date: crossmark-date,
      )
      return
    }
    if calc.odd(n) {
      author-running
      h(1fr)
      counter(page).display()
    } else {
      counter(page).display()
      h(1fr)
      title
    }
    // The header ends at its baseline (text.bottom-edge is 0pt), so the rule
    // is placed relative to that. The header is as wide as the text.
    place(
      bottom + left,
      dy: config.header-rule.gap,
      line(length: 100%, stroke: config.header-rule.stroke),
    )
  }
}

/// Style an integer affiliation number as a superscript.
#let affiliation-marker(
  number,
  baseline: config.title-block.authors.mark-raise,
) = {
  assert(
    type(number) == int,
    message: "affiliation-marker: expected an integer.",
  )
  super(..config.title-block.marks, baseline: baseline, str(number))
}

/// Link an author-side marker to an affiliation key, displaying its number.
#let affiliation-reference(key, number) = {
  let target = label("iacrj-affiliation-" + key)
  link(target, affiliation-marker(number))
}

/// Render the title, authors, affiliations, abstract and keywords.
/// Authors use normalized metadata records with affiliation keys in `inst`.
/// Affiliations are a dictionary whose insertion order sets the displayed numbers.
/// The abstract is rendered content, or `none` to omit it.
/// An empty author list renders an anonymous submission and hides affiliations.
/// This function inherits document-wide styling from its caller.
#let title-block(
  title: "",
  authors: (),
  affiliations: (:),
  abstract: none,
  keywords: (),
) = {
  let anonymous = authors.len() == 0
  let tb = config.title-block
  // Dictionary insertion order determines both numbering and display order.
  let affiliation-numbers = affiliations
    .keys()
    .enumerate()
    .map(((i, key)) => (key, i + 1))
    .to-dict()

  // With a single author or a single affiliation the numbers carry no
  // information, so neither the authors nor the affiliations get them.
  let show-inst = authors.len() > 1 and affiliations.len() > 1

  let author-names = if anonymous { ([Anonymous Submission],) } else {
    authors.map(a => box({
      a.name
      if show-inst and a.inst != none {
        a
          .inst
          .map(key => affiliation-reference(key, affiliation-numbers.at(key)))
          .join(
            super(..tb.marks, baseline: tb.authors.mark-raise, [,]),
          )
      }
      if a.footnote != none {
        // Author footnotes are lettered (a, b, ...) and placed like the
        // affiliation marks, so "1,a" reads as one superscript.
        set super(..tb.marks, baseline: tb.authors.mark-raise)
        if show-inst and a.inst != none { super[,] }
        footnote(numbering: "a", a.footnote)
      }
      if a.orcid != none { orcid(a.orcid, alt: "ORCID record for " + a.name) }
    }))
  }
  let affiliation-lines = if anonymous { () } else {
    affiliations
      .pairs()
      .enumerate()
      .map(((i, entry)) => {
        let (key, aff) = entry
        if show-inst {
          [#affiliation-marker(
              i + 1,
              baseline: tb.affiliations.mark-raise,
            )#label("iacrj-affiliation-" + key)]
          [~]
        }
        (aff.department, aff.name, aff.city, aff.country)
          .filter(x => x != none)
          .join(", ")
      })
  }
  let emails = if anonymous { () } else {
    authors.filter(a => a.email != none).map(a => a.email + " (" + a.name + ")")
  }

  set par(justify: false, first-line-indent: 0pt)
  let title-content = block({
    set par(leading: tb.title.leading)
    show std.title: it => text(..tb.title.text, it.body)
    std.title(title)
  })
  let author-content = block({
    set par(leading: tb.authors.leading)
    // Emit the unmarked email note before the names and their author notes.
    if emails.len() > 0 {
      footnote(
        numbering: n => none,
        {
          if emails.len() == 1 { "Email: " } else { "Emails: " }
          emails.join(", ")
        },
      )
      counter(footnote).update(0) // so author footnotes start at a
    }
    text(..tb.authors.text, author-names.join(", ", last: " and "))
  })
  let affiliation-content = if affiliation-lines.len() > 0 {
    (
      tb.affiliations.gap,
      block({
        set text(..tb.affiliations.text)
        set par(leading: tb.affiliations.leading)
        affiliation-lines.join(linebreak())
      }),
    )
  } else { () }

  align(center, stack(
    dir: ttb,
    tb.title.gap,
    title-content,
    tb.authors.gap,
    author-content,
    ..affiliation-content,
  ))
  // Keep the abstract in normal flow: a stack cannot break across pages.
  if abstract != none {
    block(width: 100%, above: tb.abstract.gap, {
      set text(..tb.abstract.text)
      set par(..tb.abstract.par)
      block(width: 100%, below: tb.abstract.heading-gap, {
        set align(center)
        show heading: it => text(..tb.abstract.text, weight: "bold", it.body)
        heading(level: 1, numbering: none, outlined: false, [Abstract])
      })
      pad(x: tb.abstract.margin, abstract)
    })
  }
  if keywords.len() > 0 {
    block(above: tb.keywords.gap)[#text(
        ..tb.keywords.label,
      )[Keywords:]~#keywords.join(", ")]
  }
  // Author and email footnotes don't count: the paper's first footnote is 1.
  counter(footnote).update(0)
}

// The template itself. `iacrmetadata` is the text of main.iacrmetadata, or
// none without one; authors use `iacrj` below, which takes it from the compiler instead.
#let _iacrj(
  iacrmetadata: none,
  journal: none, // required: "cic", "tosc" or "tches"
  version: "preprint",
  notanonymous: false,
  line-numbers: auto,
  title: "",
  authors: (),
  affiliations: (:),
  abstract: "",
  keywords: (),
  bibliography: (),
  license: none,
  enable-checks: true,
  body,
) = {
  let from-string = (self, it) => if type(it) == str { (name: it) } else { it }
  let parsing = (
    // Authors refer to affiliation keys: inst: "rub" or ("rub", "other").
    author: z.dictionary(
      (
        name: z.string(min: 1),
        surname: z.string(min: 1, optional: true),
        footnote: z.string(min: 1, optional: true),
        inst: z.array(z.string(min: 1), optional: true, pre-transform: (
          self,
          it,
        ) => if type(it) == str { (it,) } else { it }),
        orcid: z.string(optional: true),
        email: z.string(optional: true),
      ),
      pre-transform: from-string,
    ),
    // \addaffiliation: (name: .., department: .., city: .., country: ..)
    affiliation: z.dictionary(
      (
        name: z.string(min: 1),
        department: z.string(optional: true),
        city: z.string(optional: true),
        country: z.string(optional: true),
      ),
      pre-transform: from-string,
    ),
  )

  // Validate each keyed record without changing the dictionary's insertion order.
  let affiliation-schema = if type(affiliations) == dictionary {
    affiliations.keys().map(key => (key, parsing.affiliation)).to-dict()
  } else { (:) }

  let args = z.parse(
    (
      journal: journal,
      version: version,
      notanonymous: notanonymous,
      line-numbers: line-numbers,
      title: title,
      authors: authors,
      affiliations: affiliations,
      abstract: abstract,
      keywords: keywords,
      bibliography: bibliography,
      license: license,
    ),
    z.dictionary((
      // The IACR journal: Communications in Cryptology (cic), Transactions
      // on Symmetric Cryptology (tosc) or Transactions on Cryptographic
      // Hardware and Embedded Systems (tches), like iacrj.cls's journal= option.
      journal: z.choice(
        ("cic", "tosc", "tches"),
        pre-transform: (self, it) => {
          assert(
            it != none,
            message: "iacrj: `journal` is required. Use \"cic\", \"tosc\" or \"tches\".",
          )
          it
        },
      ),
      // iacrj.cls's version= option. Only the final version gets the
      // journal header on the first page; a submission is anonymous.
      version: z.choice(("preprint", "submission", "final")),
      // iacrj.cls's notanonymous option: show the authors in a submission.
      notanonymous: z.boolean(),
      // Number the lines, like lineno in iacrj.cls. `auto` (validated as
      // none) numbers them in submissions only.
      line-numbers: z.boolean(optional: true),
      // Either "Title" or (full: "Long Title", short: "Short Title").
      // The short title is used in the running head (\titlerunning).
      // A plain string is turned into (full: it, short: it) before validation.
      title: z.dictionary(
        (full: z.string(min: 1), short: z.string(min: 1)),
        pre-transform: (self, it) => if type(it) == str {
          (full: it, short: it)
        } else { it },
      ),
      authors: z.array(parsing.author, min: 1),
      affiliations: z.dictionary(affiliation-schema),
      // A string of Typst markup, usually `read("abstract.typ")`. It is
      // rendered with eval, and the string itself goes into the metadata, so
      // the metadata keeps the exact source (math included). Content is
      // rejected because Typst cannot turn content back into source text.
      // (content: .., text: ..) supplies both forms explicitly.
      abstract: z.dictionary(
        (content: z.content(), text: z.string()),
        pre-transform: (self, it) => {
          assert(
            type(it) != content,
            message: "iacrj: `abstract` must be a string of Typst markup, not content, "
              + "so its source can be saved in the metadata. "
              + "Put it in a file and use `abstract: read(\"abstract.typ\")`.",
          )
          if type(it) == str {
            (content: eval(it, mode: "markup"), text: it)
          } else { it }
        },
      ),
      keywords: z.array(z.string()),
      bibliography: z.array(
        z.string(min: 1),
        default: none,
        pre-transform: (self, it) => if type(it) == str { (it,) } else { it },
      ),
      // An SPDX license identifier such as "CC-BY-4.0" (iacrj.cls's
      // \license). Only Creative Commons licenses are supported.
      license: z.choice(_licenses.keys(), optional: true),
    )),
    scope: ("iacrj",),
    ctx: z.z-ctx(strict: true), // reject unknown keys, e.g. (full: .., shrot: ..)
  )

  assert(
    args.version != "final" or args.license != none,
    message: "iacrj: version: \"final\" requires a license, "
      + "e.g. license: \"CC-BY-4.0\".",
  )

  for author in args.authors {
    for key in author.inst {
      assert(
        key in args.affiliations,
        message: "iacrj: unknown affiliation key "
          + repr(key)
          + " for author "
          + repr(author.name)
          + ".",
      )
    }
  }

  // Read all sources before parsing: BibTeX string aliases may be defined
  // in a different file from the entries that use them. Paths are root-relative.
  let bibliography-source = args
    .bibliography
    .map(file => read("/" + file.trim(at: start, "/"), encoding: none))
    .join(bytes("\n"))

  // Volume and issue for the first-page header (\IACR@vol, \IACR@no).
  let iacr = _parse-iacrmetadata(iacrmetadata)

  let (full: full-title, short: short-title) = args.title
  let config = config
  let journal = config.journals.at(args.journal)

  // A submission hides the authors and affiliations everywhere: title block,
  // running head, PDF metadata and <iacrj-meta> (iacrj.cls's anonymous mode).
  let anonymous = args.version == "submission" and not args.notanonymous
  let line-numbers = if args.line-numbers == none {
    args.version == "submission"
  } else { args.line-numbers }
  let author-names = args.authors.map(a => a.name)

  config.document = (
    title: [#full-title],
    author: if anonymous { ("hidden for submission",) } else { author-names },
    keywords: args.keywords,
    description: if args.version == "final" {
      [#(
        journal.name + if iacr.doi != none { ", DOI: " + iacr.doi } else { "" }
      )]
    },
  )
  config.page.header = page-header(
    journal,
    title: short-title,
    authors: if anonymous { () } else { args.authors },
    version: args.version,
    volume: iacr.volume,
    issue: iacr.issue,
    doi: iacr.doi,
    crossmark-date: iacr.crossmark-date,
  )

  let check(elem, config, actual: none, name: none) = {
    let name = if name == none { repr(elem) } else { name }
    let get(key) = if actual == none {
      eval("e => e." + key)(elem)
    } else {
      actual.at(key)
    }
    let changed = config.keys().filter(k => get(k) != config.at(k))
    if changed == () { return }

    let describe(k) = {
      let field = "`" + name + "." + k + "`"
      if type(config.at(k)) in (content, bytes) {
        // Headers and CSL data are not useful to print in an error message.
        field + " was changed"
      } else {
        (
          field
            + " is "
            + repr(get(k))
            + ", but the template requires "
            + repr(config.at(k))
        )
      }
    }

    panic(
      "The iacrj template does not allow changing these settings:\n"
        + changed.map(k => "  - " + describe(k)).join("\n")
        + "\nRemove the conflicting `set "
        + name
        + "(...)` rules or explicit element arguments.",
    )
  }

  let config-checks(display-equation: false) = context {
    if not enable-checks { return }
    // Equation spacing is local to its show rule; paragraph context cannot
    // observe it. Math also intentionally uses different text settings.
    if display-equation {
      check(block, config.equation)
      return
    }
    check(
      text,
      if text.font == config.raw.font {
        config.text + (font: config.raw.font)
      } else { config.text },
    )
    check(page, config.page)
    check(document, config.document)
    check(par, config.par)
    check(list, config.list)
    check(enum, config.enum)
    check(heading, (numbering: config.heading.numbering))
    check(figure, config.figure)
    check(footnote.entry, config.footnote.entry, name: "footnote.entry")
    check(std.bibliography, config.bibliography)
    check(cite, config.cite)
  }

  set document(..config.document)
  set page(..config.page)
  set text(..config.text)
  set par(..config.par)
  // Line numbers help reviewers refer to the text (iacrj.cls loads lineno).
  set par.line(
    numbering: n => text(..config.line-numbers, str(n)),
  ) if line-numbers
  set std.bibliography(..config.bibliography)
  set cite(..config.cite)
  show math.equation.where(block: true): set block(..config.equation)
  show math.equation.where(block: true): it => {
    config-checks(display-equation: true)
    it
  }

  // Also check explicit citation style arguments, not just set rules.
  show cite: it => if enable-checks {
    context {
      check(cite, config.cite, actual: it)
      it
    }
  } else { it }

  set list(..config.list)
  set enum(..config.enum)
  show list: set block(..config.list-block)
  show enum: set block(..config.list-block)

  set heading(numbering: config.heading.numbering)
  // Customizing spacing using set rule not supported.
  // https://github.com/typst/typst/issues/2351
  show heading.where(numbering: config.heading.numbering): it => block({
    counter(heading).display(it.numbering)
    h(1em)
    it.body
  })

  // A for loop introduces a local scope, so one needs to be careful to make
  // sure the show set rules apply
  let levels = config.heading.levels
  show heading.where(level: 1): set text(..levels.at(0).text)
  show heading.where(level: 1): set block(..levels.at(0).block)
  show heading.where(level: 2): set text(..levels.at(1).text)
  show heading.where(level: 2): set block(..levels.at(1).block)
  show heading.where(level: 3): set text(..levels.at(2).text)
  show heading.where(level: 3): set block(..levels.at(2).block)

  show raw: set text(..config.raw)

  set figure(..config.figure)
  show figure.where(kind: table): set figure.caption(..config.table-caption)
  show figure.caption: it => context {
    text(..config.caption-label)[#it.supplement~#it.counter.display(
        it.numbering,
      )#it.separator]
    it.body
  }

  set footnote.entry(..config.footnote.entry)
  show footnote.entry: set text(..config.footnote.text)
  show footnote.entry: set par(..config.footnote.par)
  show footnote.entry: set par.line(numbering: none) // as in lineno

  show link: it => if type(it.dest) == str {
    text(fill: config.colors.url, it)
  } else { it }
  show ref: set text(fill: config.colors.link)
  show cite: set text(fill: config.colors.cite)
  show outline.entry: set text(fill: config.colors.link)

  let meta = (
    journal: args.journal,
    version: args.version,
    volume: iacr.volume,
    issue: iacr.issue,
    title: (full: full-title, short: short-title),
    authors: if anonymous { () } else { args.authors },
    affiliations: if anonymous { (:) } else { args.affiliations },
    license: args.license,
  )
  if args.version == "final" {
    meta.doi = iacr.doi
    meta.crossmark-date = iacr.crossmark-date
    meta.crossmark-url = if iacr.doi != none and iacr.crossmark-date != none {
      _crossmark-url(iacr.doi, iacr.crossmark-date)
    }
    meta.date-received = iacr.date-received
    meta.date-accepted = iacr.date-accepted
    meta.date-revised = iacr.date-revised
    meta.date-final = iacr.date-final
  }
  // It is still unclear how the publishing pipeline should retrieve these
  // source files; record their names rather than exporting the combined data.
  meta.bibliography = args.bibliography
  meta.keywords = args.keywords
  let abstract-text = args.abstract.text

  // The number of physical pages through the paper-end marker below.
  let paper-pages() = {
    let ends = query(metadata.where(value: "iacrj-paper-end"))
    // The template's boundary follows any matching markers in author content.
    if ends.len() > 0 { ends.last().location().page() }
  }

  let front-matter = title-block(
    title: full-title,
    authors: if anonymous { () } else { args.authors },
    affiliations: if anonymous { (:) } else { args.affiliations },
    abstract: if args.abstract.text != "" { args.abstract.content },
    keywords: args.keywords,
  )

  let paper = {
    // This rule covers author content only; the template's bibliography is
    // appended outside this scope. Source filenames are required for metadata,
    // so manual calls are rejected even when style checks are disabled.
    show std.bibliography: _ => panic(
      "iacrj: do not call bibliography(...) manually. "
        + "Pass your BibTeX filenames with the iacrj bibliography option instead, "
        + "e.g. bibliography: (\"references.bib\",).",
    )
    // Placed first so that it lands on page 1. A submission shows no
    // license, as in iacrj.cls; HTML has no pages.
    if args.license != none and args.version != "submission" {
      context if target() != "html" {
        place-first-page-footer(
          journal,
          args.license,
          version: args.version,
          dates: iacr,
        )
      }
    }
    front-matter

    // The title-block customizes spacing, so should not be checked
    if enable-checks {
      show par: it => {
        config-checks()
        it
      }
      body
    } else {
      body
    }
    // An invisible boundary records the last physical page of the paper,
    // including front matter but excluding any bibliography-only pages.
    metadata("iacrj-paper-end")
  }
  // The metadata for the publishing pipeline, queried from the command line:
  //   typst query main.typ '<iacrj-meta>' --field value --one
  // HTML output has no pages.
  context [#metadata(
    meta
      + (
        pages: if target() != "html" { paper-pages() },
        abstract: abstract-text,
      ),
  )<iacrj-meta>]
  paper
  if args.bibliography.len() > 0 {
    std.bibliography(bibliography-source)
  }
}

/// The iacrj template. The publisher supplies journal metadata (volume,
/// issue, doi, crossmark-date, date-received, date-accepted, date-revised
/// and date-final) for the final version in a file like the
/// \jobname.iacrmetadata file that iacrj.cls reads, named on the command line
/// relative to the project root:
///
///   typst compile --input iacrmetadata=main.iacrmetadata main.typ
///
/// Without the input, the document compiles without these values. Authors
/// cannot set them in the document.
#let iacrj(..args) = {
  assert(
    "iacrmetadata" not in args.named(),
    message: "iacrj: the journal metadata is supplied by the publisher, not the document.",
  )
  // Typst cannot test whether a file exists, so read it only when named.
  let file = sys.inputs.at("iacrmetadata", default: "").trim()
  let iacrmetadata = if file == "" { none } else {
    read("/" + file.trim(at: start, "/"))
  }
  _iacrj(iacrmetadata: iacrmetadata, ..args)
}
