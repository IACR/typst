#import "@preview/valkyrie:0.2.2" as z

// Fonts. New Computer Modern is bundled with Typst; the sans and mono
// variants (closest to Latin Modern Sans/Mono) must be installed.
#let serif = ("new computer modern")
#let sans = ("new computer modern sans")
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
      margin: (top: 37.125mm + 3pt, bottom: 37.125mm, left: 36.75mm, right: 36.75mm),
      numbering: "1",
      header-ascent: 31.5pt, // header baseline 28.5pt above the text block
      footer: none,
    ),
    // Name and ISSN of each journal (\publname and \IACR@EISSN).
    journals: (
      cic: (name: "IACR Communications in Cryptology", issn: "3006-5496"),
      tosc: (name: "IACR Transactions on Symmetric Cryptology", issn: "2519-173X"),
      tches: (name: "IACR Transactions on Cryptographic Hardware and Embedded Systems", issn: "2569-2925"),
    ),
    // First-page header (fancypagestyle title): \small, 9pt on 11pt.
    // Its two lines don't fit in \headheight (12pt), so fancyhdr enlarges it
    // to 20.5pt, which moves the header 8.5pt down towards the text.
    first-page-header: (text: (size: 9pt), leading: 4.7pt, dy: 8.5pt, updates-gap: 2pt),
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

    // article.cls headings. CiC: serif bold; ToSC/TCHES: sans bold (sectsty).
    // TODO: check spacing
    heading: (
      numbering: "1.1",
      levels: (
        // \section, \Large: 33.3pt above / 22.0pt below (baseline to baseline)
        (text: (size: 14.4pt, weight: "bold"), block: (above: 23.2pt, below: 15pt)),
        // \subsection, \large: 27.4pt / 18.4pt
        (text: (size: 12pt, weight: "bold"), block: (above: 19pt, below: 11.4pt)),
        // \subsubsection, \normalsize: 26.3pt / 18.4pt
        (text: (size: 10pt, weight: "bold"), block: (above: 19.3pt, below: 11.4pt)),
      ),
    ),

    // itemize/enumerate: label at 12pt, text at 25pt (\leftmargini = 2.5em),
    // \itemsep + \parsep = 8.2pt between items and around the list.
    list: (indent: 12.1pt, body-indent: 5pt, spacing: 13.2pt, marker: ([•], [–], [∗], [·])),
    enum: (indent: 12.1pt, body-indent: 5pt, spacing: 13.2pt),
    list-block: (above: 13.2pt, below: 13.2pt),

    // \texttt: Latin Modern Mono at the text size (Typst scales raw to 0.8em).
    raw: (font: mono, size: 1.25em),

    // float package (iacrabove/iacrbelow): "Figure 1:" in sans bold,
    // table captions above the table.
    figure: (gap: 10pt),
    table-caption: (position: top),
    caption-label: (font: sans, weight: "bold"),

    // \footnotesize (8pt on 9.5pt), rule of 0.4\textwidth, text at 1.8em.
    footnote: (
      entry: (separator: line(length: 40%, stroke: 0.4pt), indent: 18pt),
      text: (size: 8pt),
      par: (leading: 3.9pt),
    ),

    // hyperref colorlinks for journal=cic
    colors: (
      url: rgb(0, 0, 255), // urlcolor=blue
      link: rgb(77, 0, 0), // linkcolor=black!70!red
      cite: rgb(0, 77, 0), // citecolor=black!70!green
    ),

    // \maketitle of metacapture (maketitle=iacrj), abstract and keywords.
    // `gap` is the space above each part; together they reproduce the
    // baselines of iacrj-doc.pdf.
    title-block: (
      // \LARGE\bfseries\sffamily: 17.28pt on 22pt
      title: (gap: 36.8pt, text: (size: 17.28pt, font: sans, weight: "bold"), leading: 9.9pt),
      // \large\sffamily\bfseries
      subtitle: (gap: 15.1pt, text: (size: 12pt, font: sans, weight: "bold")),
      // \large: 12pt on 14.5pt
      authors: (gap: 19.4pt, text: (size: 12pt), leading: 6.1pt, mark-raise: -0.37em),
      // \small: 9pt on 11pt
      affiliations: (gap: 16.4pt, text: (size: 9pt), leading: 4.7pt, mark-raise: -0.42em),
      // superscript affiliation numbers (\scriptsize relative to the line)
      marks: (typographic: false, size: 0.667em),
      // article abstract: \small, quotation margins 2.5em, indent 1.5em
      abstract: (
        gap: 29.8pt,
        heading-gap: 4.6pt,
        text: (size: 9pt),
        par: (leading: 4.7pt, spacing: 4.7pt, justify: true, first-line-indent: (amount: 1.5em, all: false)),
        margin: 25pt,
      ),
      // \textbf{\textsf{Keywords:}}~
      keywords: (gap: 12.2pt, label: (font: sans, weight: "bold")),
    ),
  )

// Downloaded from https://info.orcid.org/documentation/integration-guide/orcid-id-display-guidelines/
#let _orcid-icon = image.with(
  bytes(```
<svg width="32" height="32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M32 16c0 8.837-7.163 16-16 16-8.838 0-16-7.163-16-16C0 7.162 7.162 0 16 0c8.837 0 16 7.162 16 16Z" fill="#A6CE39"/>
  <path fill-rule="evenodd" clip-rule="evenodd" d="M18.813 9.637h-5.45v13.9h5.474c4.555 0 7.35-3.378 7.35-6.95 0-1.635-.562-3.372-1.77-4.704-1.215-1.336-3.065-2.246-5.605-2.246ZM18.6 21.3h-2.813v-9.425H18.5c1.823 0 3.12.552 3.96 1.4.842.849 1.252 2.021 1.252 3.312 0 .784-.239 1.967-.993 2.948-.745.969-2.01 1.765-4.119 1.765Zm5.311-4.026c-.251 1.74-1.494 4.276-5.311 4.276h-3.063H18.6c3.817 0 5.06-2.536 5.311-4.276Zm1.812-2.405c-.657-2.601-2.85-4.982-6.91-4.982h-5.2 5.2c4.06 0 6.253 2.38 6.91 4.982Zm.215 1.718ZM8.363 9.675v13.887h2.425V9.675H8.363Zm2.175 13.637H8.612h1.925ZM9.575 8.65c.84 0 1.513-.689 1.513-1.513 0-.823-.673-1.512-1.513-1.512-.838 0-1.512.674-1.512 1.513 0 .823.672 1.512 1.512 1.512Z" fill="#fff"/>
</svg>
  ```.text),
  alt: "ORCID iD",
  format: "svg",
)

#let _checksum_valid(id) = {
  // ISO 7064 MOD 11-2 check digit over the first 15 digits.
  let total = id.slice(0, 15).clusters().map(int).fold(0, (acc, d) => (acc + d) * 2)
  let check = calc.rem(12 - calc.rem(total, 11), 11)
  let expected = if check == 10 { "X" } else { str(check) }
  return id.last() == expected
}

/// ORCID iD icon linking to the author's ORCID record, like `\OrcidLink` in
/// metacapture.sty (used by iacrj.cls): the "authenticated" logo, sitting on
/// the baseline with a 0.2em gap after the author name and affiliation marks.
/// The default height matches the cap height of the 12pt New Computer Modern authors.
///
/// Accepts e.g. "0000-0002-1825-0097", "0000 0002 1825 0097",
/// "0000000218250097", "https://orcid.org/0000-0002-1825-0097",
/// "orcid.org/0000-0002-1825-009x". Panics on malformed IDs and wrong checksums.
#let orcid(id, height: 8.2pt, hor-margin: 0.2em) = {
  assert(
    type(id) == str,
    message: "orcid: expected a string like \"0000-0002-1825-0097\", got " + repr(type(id)),
  )

  // Normalize: drop URL prefix, spaces and hyphens; uppercase the check digit.
  let id = upper(
    id.trim().replace(regex("^(?i)(https?://)?(www\.)?orcid\.org/"), "").replace(regex("[\s-]"), ""),
  )
  if id.match(regex("^\d{15}[\dX]$")) == none {
    panic("orcid: \"" + id + "\" is not a valid ORCID. Expected 16 characters like 0000-0002-1825-0097 (the last one may be X).")
  }

  if not _checksum_valid(id) {
    panic(
      "orcid: \"" + id + "\" has an invalid checksum. Check the ORCID for typos.",
    )
  }

  let formatted = range(4).map(i => id.slice(i * 4, i * 4 + 4)).join("-")

  // metacapture uses a 0.2em gap in other author layouts; keep the spacing
  // here rather than relying on a literal space at each call site.
  link("https://orcid.org/" + formatted, box(inset: (left: hor-margin), _orcid-icon(height: height)))
}


#let _crossmark-icon = ```svg
  <svg id="ColourRecttxt296x64" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 296 64"><defs><style>.cls-1{stroke:#948f8f;stroke-miterlimit:10;stroke-width:0.75px;fill:url(#linear-gradient);}.cls-2{fill:#535353;}.cls-3{fill:#c72914;}.cls-4{fill:#ef3340;}.cls-5{fill:#3eb1c8;}.cls-6{fill:#ffc72c;}</style><linearGradient id="linear-gradient" x1="148" y1="10.33" x2="148" y2="59.82" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#c4c4c4"/></linearGradient></defs><title>CROSSMARK_logo_4</title><rect class="cls-1" x="4" y="4" width="288" height="56" rx="2" ry="2"/><path class="cls-2" d="M83.3,26.58a6.4,6.4,0,0,0-.55-1.43,3.92,3.92,0,0,0-2.19-1.86A5.1,5.1,0,0,0,78.85,23a5,5,0,0,0-2.46.58,4.83,4.83,0,0,0-1.69,1.54,6.92,6.92,0,0,0-1,2.19,10.16,10.16,0,0,0,0,5,6.92,6.92,0,0,0,1,2.19A4.83,4.83,0,0,0,76.39,36a5,5,0,0,0,2.46.58,4.44,4.44,0,0,0,1.85-.36,4.12,4.12,0,0,0,1.38-1,4.7,4.7,0,0,0,.9-1.49A7.1,7.1,0,0,0,83.4,32h3a8.46,8.46,0,0,1-.69,2.92,7.18,7.18,0,0,1-1.59,2.29,7,7,0,0,1-2.35,1.49,8.14,8.14,0,0,1-3,.52,8.43,8.43,0,0,1-3.59-.74,7.88,7.88,0,0,1-2.69-2,9,9,0,0,1-1.69-3,11.41,11.41,0,0,1,0-7.23,9,9,0,0,1,1.69-3,8,8,0,0,1,2.69-2,8.3,8.3,0,0,1,3.59-.75,9.44,9.44,0,0,1,2.83.41A7.3,7.3,0,0,1,84,22.09,6.23,6.23,0,0,1,85.65,24a6.66,6.66,0,0,1,.78,2.58H83.3Z"/><path class="cls-2" d="M88.9,20.9h2.85v6.63H91.8a4.15,4.15,0,0,1,1.56-1.46,4.61,4.61,0,0,1,2.31-.59A4.83,4.83,0,0,1,99,26.58a4.21,4.21,0,0,1,1.22,3.3v8.88H97.4V30.63a3.51,3.51,0,0,0-.65-2.21,2.36,2.36,0,0,0-1.87-.69,3.1,3.1,0,0,0-1.3.26,2.82,2.82,0,0,0-1,.73A3.41,3.41,0,0,0,92,29.8a3.88,3.88,0,0,0-.23,1.33v7.63H88.9V20.9Z"/><path class="cls-2" d="M105.47,33a5,5,0,0,0,.21,1.45,3.56,3.56,0,0,0,.64,1.23,3.08,3.08,0,0,0,1.08.84,3.54,3.54,0,0,0,1.55.31,3.43,3.43,0,0,0,2-.54,3.18,3.18,0,0,0,1.14-1.61h2.7A5.35,5.35,0,0,1,112.7,38a5.72,5.72,0,0,1-1.74.85,7,7,0,0,1-2,.29,6.85,6.85,0,0,1-2.7-.5,5.58,5.58,0,0,1-2-1.4A5.94,5.94,0,0,1,103,35a8.75,8.75,0,0,1-.41-2.75,7.77,7.77,0,0,1,.44-2.61,6.67,6.67,0,0,1,1.25-2.17,5.86,5.86,0,0,1,4.56-2,5.79,5.79,0,0,1,2.74.64,6,6,0,0,1,2,1.69,6.83,6.83,0,0,1,1.16,2.41A7.38,7.38,0,0,1,115,33h-9.5Zm6.65-1.87a4.6,4.6,0,0,0-.29-1.3,3.48,3.48,0,0,0-.65-1.09,3.22,3.22,0,0,0-1-.75,3,3,0,0,0-1.31-.29,3.43,3.43,0,0,0-1.36.26,3.11,3.11,0,0,0-1,.73,3.59,3.59,0,0,0-.7,1.09,3.8,3.8,0,0,0-.29,1.35h6.65Z"/><path class="cls-2" d="M125.88,30.15a2.67,2.67,0,0,0-1-1.81,3.14,3.14,0,0,0-2-.61,4.1,4.1,0,0,0-1.18.19,2.79,2.79,0,0,0-1.15.7,3.92,3.92,0,0,0-.87,1.43,6.78,6.78,0,0,0-.35,2.39,7,7,0,0,0,.19,1.6,4.36,4.36,0,0,0,.6,1.43,3.24,3.24,0,0,0,1.06,1,3,3,0,0,0,1.58.39,2.87,2.87,0,0,0,2.06-.77,3.6,3.6,0,0,0,1-2.18h2.85a6.26,6.26,0,0,1-1.91,3.86,5.83,5.83,0,0,1-4,1.34,6.61,6.61,0,0,1-2.69-.51,5.69,5.69,0,0,1-2-1.4,6,6,0,0,1-1.21-2.11,8.27,8.27,0,0,1-.41-2.65,9,9,0,0,1,.4-2.72,6.23,6.23,0,0,1,1.2-2.21,5.61,5.61,0,0,1,2-1.47,6.7,6.7,0,0,1,2.79-.54,7.8,7.8,0,0,1,2.14.29,5.63,5.63,0,0,1,1.8.86,4.58,4.58,0,0,1,1.29,1.45,5,5,0,0,1,.6,2.07h-2.85Z"/><path class="cls-2" d="M131.13,20.9H134V31l5.15-5.22h3.5l-5,4.75,5.42,8.17h-3.47l-4-6.27L134,34.13v4.63h-2.85V20.9Z"/><path class="cls-2" d="M150.15,25.83h2.13V24.75a5.51,5.51,0,0,1,.3-2,2.81,2.81,0,0,1,.8-1.18,2.63,2.63,0,0,1,1.14-.55,6.34,6.34,0,0,1,1.34-.14,8.16,8.16,0,0,1,2,.18V23.3a4.1,4.1,0,0,0-.59-0.11,6.33,6.33,0,0,0-.74,0,1.74,1.74,0,0,0-1,.27,1.21,1.21,0,0,0-.41,1.08v1.33h2.42V28h-2.42v10.8h-2.85V28h-2.12V25.83Z"/><path class="cls-2" d="M165.23,39.1a7,7,0,0,1-2.76-.51,5.88,5.88,0,0,1-2-1.41A6,6,0,0,1,159.14,35a8.78,8.78,0,0,1,0-5.48,6,6,0,0,1,1.27-2.15,5.89,5.89,0,0,1,2-1.41A7.71,7.71,0,0,1,168,26a5.89,5.89,0,0,1,2,1.41,6,6,0,0,1,1.28,2.15,8.78,8.78,0,0,1,0,5.48A6,6,0,0,1,170,37.17a5.88,5.88,0,0,1-2,1.41A7,7,0,0,1,165.23,39.1Zm0-2.25a3.27,3.27,0,0,0,1.65-.4A3.48,3.48,0,0,0,168,35.4a4.56,4.56,0,0,0,.66-1.46,6.58,6.58,0,0,0,0-3.31,4.41,4.41,0,0,0-.66-1.46,3.53,3.53,0,0,0-1.15-1,3.6,3.6,0,0,0-3.3,0,3.53,3.53,0,0,0-1.15,1,4.4,4.4,0,0,0-.66,1.46,6.55,6.55,0,0,0,0,3.31,4.56,4.56,0,0,0,.66,1.46,3.47,3.47,0,0,0,1.15,1.05A3.26,3.26,0,0,0,165.23,36.85Z"/><path class="cls-2" d="M174.13,25.83h2.67v2.5h0a2.9,2.9,0,0,1,.49-1,4.74,4.74,0,0,1,.88-0.91,4.4,4.4,0,0,1,1.14-.66,3.41,3.41,0,0,1,1.28-.25,6.21,6.21,0,0,1,.69,0l0.39,0V28.3l-0.61-.09a5.18,5.18,0,0,0-.61,0,3.28,3.28,0,0,0-1.36.29,3.13,3.13,0,0,0-1.11.85,4.17,4.17,0,0,0-.75,1.39,6,6,0,0,0-.28,1.9v6.15h-2.85V25.83Z"/><path class="cls-2" d="M201.22,38.75h-2.8V37h0a3.91,3.91,0,0,1-1.56,1.56,4.25,4.25,0,0,1-2.11.59A4.74,4.74,0,0,1,191,37.84,5.54,5.54,0,0,1,189.88,34v-8.2h2.85v7.92a3.5,3.5,0,0,0,.65,2.4,2.37,2.37,0,0,0,1.83.7,3.6,3.6,0,0,0,1.5-.27,2.66,2.66,0,0,0,1-.74,2.84,2.84,0,0,0,.54-1.11,5.8,5.8,0,0,0,.16-1.4v-7.5h2.85V38.75Z"/><path class="cls-2" d="M204.3,25.83H207v1.75h0A3.52,3.52,0,0,1,208.72,26a5.57,5.57,0,0,1,2.33-.49,6.17,6.17,0,0,1,2.66.54,5.25,5.25,0,0,1,1.89,1.47,6.41,6.41,0,0,1,1.13,2.19,9.27,9.27,0,0,1,.38,2.68,9.44,9.44,0,0,1-.34,2.52,6.56,6.56,0,0,1-1,2.16,5,5,0,0,1-4.21,2.06,7,7,0,0,1-1.25-.11,5.39,5.39,0,0,1-1.2-.36A4.73,4.73,0,0,1,208,38a3.55,3.55,0,0,1-.81-0.91h0v6.45H204.3V25.83Zm10,6.47a6.41,6.41,0,0,0-.23-1.7,4.6,4.6,0,0,0-.67-1.46,3.48,3.48,0,0,0-1.12-1,3.06,3.06,0,0,0-1.55-.39A3.14,3.14,0,0,0,208,29,5.52,5.52,0,0,0,207,32.3a6.62,6.62,0,0,0,.24,1.81,4.06,4.06,0,0,0,.71,1.44,3.55,3.55,0,0,0,1.14,1,3.24,3.24,0,0,0,1.54.35,3.18,3.18,0,0,0,1.65-.4,3.49,3.49,0,0,0,1.11-1,4.22,4.22,0,0,0,.63-1.45A7.37,7.37,0,0,0,214.25,32.3Z"/><path class="cls-2" d="M231.67,38.75H229V37h0a3.38,3.38,0,0,1-1.67,1.61,5.67,5.67,0,0,1-2.33.49,6.17,6.17,0,0,1-2.66-.54,5.31,5.31,0,0,1-1.89-1.46,6.26,6.26,0,0,1-1.12-2.19,9.48,9.48,0,0,1-.37-2.71,8.68,8.68,0,0,1,.47-3,6.06,6.06,0,0,1,1.26-2.1,4.89,4.89,0,0,1,1.8-1.21,5.74,5.74,0,0,1,2.06-.39,6.94,6.94,0,0,1,1.23.11,5.44,5.44,0,0,1,1.2.36,4.74,4.74,0,0,1,1.06.64,3.56,3.56,0,0,1,.81.91h0V20.9h2.85V38.75Zm-10-6.33a6.3,6.3,0,0,0,.21,1.63,4.44,4.44,0,0,0,.65,1.43,3.28,3.28,0,0,0,1.11,1,3.24,3.24,0,0,0,1.6.38,3.2,3.2,0,0,0,1.64-.4,3.4,3.4,0,0,0,1.13-1.05,4.78,4.78,0,0,0,.65-1.46,6.59,6.59,0,0,0,.21-1.66,5.23,5.23,0,0,0-1-3.35,3.17,3.17,0,0,0-2.61-1.2,3.23,3.23,0,0,0-1.69.41,3.48,3.48,0,0,0-1.12,1.07,4.48,4.48,0,0,0-.62,1.5A7.82,7.82,0,0,0,221.72,32.42Z"/><path class="cls-2" d="M245.6,35.88a1.51,1.51,0,0,0,.14.75,0.58,0.58,0,0,0,.54.23h0.3a1.86,1.86,0,0,0,.4-0.05v2l-0.39.11L246.1,39l-0.5.08-0.42,0a2.75,2.75,0,0,1-1.45-.35,1.74,1.74,0,0,1-.75-1.23,5,5,0,0,1-2.09,1.2,8.22,8.22,0,0,1-2.39.38,5.86,5.86,0,0,1-1.67-.24,4.39,4.39,0,0,1-1.41-.7,3.35,3.35,0,0,1-1-1.18,3.62,3.62,0,0,1-.36-1.66,3.84,3.84,0,0,1,.44-2,3.24,3.24,0,0,1,1.15-1.17,5.19,5.19,0,0,1,1.6-.61q0.89-.19,1.79-0.29a14.77,14.77,0,0,1,1.47-.21,6.9,6.9,0,0,0,1.24-.21,1.9,1.9,0,0,0,.85-0.46,1.28,1.28,0,0,0,.31-0.94,1.46,1.46,0,0,0-.26-0.9A1.76,1.76,0,0,0,242,28a2.81,2.81,0,0,0-.86-0.25,6.94,6.94,0,0,0-.9-0.06,3.58,3.58,0,0,0-2,.5,2,2,0,0,0-.87,1.55h-2.85a4.29,4.29,0,0,1,.6-2.07,4.14,4.14,0,0,1,1.34-1.33,5.48,5.48,0,0,1,1.84-.7,11,11,0,0,1,2.1-.2,8.89,8.89,0,0,1,1.88.2,5.34,5.34,0,0,1,1.66.65,3.6,3.6,0,0,1,1.19,1.16,3.19,3.19,0,0,1,.45,1.74v6.65Zm-2.85-3.6a3.45,3.45,0,0,1-1.6.51q-1,.09-1.9.26a6.12,6.12,0,0,0-.87.21,2.65,2.65,0,0,0-.75.38,1.64,1.64,0,0,0-.51.63,2.14,2.14,0,0,0-.19.94,1.19,1.19,0,0,0,.27.8,2,2,0,0,0,.66.51,3,3,0,0,0,.85.26,5.25,5.25,0,0,0,.84.08,4.63,4.63,0,0,0,1-.12,3.42,3.42,0,0,0,1-.43,2.73,2.73,0,0,0,.81-0.76,1.93,1.93,0,0,0,.32-1.14V32.27Z"/><path class="cls-2" d="M247.37,25.83h2.15V22h2.85v3.88h2.58V28h-2.58v6.9a7,7,0,0,0,0,.77,1.34,1.34,0,0,0,.17.55,0.84,0.84,0,0,0,.41.34,2,2,0,0,0,.75.11h0.6a2.93,2.93,0,0,0,.6-0.09v2.2l-0.93.1a8.4,8.4,0,0,1-.92,0,6.33,6.33,0,0,1-1.81-.21,2.42,2.42,0,0,1-1.08-.62,2.15,2.15,0,0,1-.52-1,7.78,7.78,0,0,1-.16-1.42V28h-2.15V25.83Z"/><path class="cls-2" d="M259.22,33a5,5,0,0,0,.21,1.45,3.56,3.56,0,0,0,.64,1.23,3.08,3.08,0,0,0,1.08.84,3.54,3.54,0,0,0,1.55.31,3.43,3.43,0,0,0,2-.54,3.18,3.18,0,0,0,1.14-1.61h2.7a5.35,5.35,0,0,1-2.1,3.26,5.72,5.72,0,0,1-1.74.85,7,7,0,0,1-2,.29,6.85,6.85,0,0,1-2.7-.5,5.58,5.58,0,0,1-2-1.4A5.94,5.94,0,0,1,256.79,35a8.75,8.75,0,0,1-.41-2.75,7.77,7.77,0,0,1,.44-2.61,6.67,6.67,0,0,1,1.25-2.17,5.86,5.86,0,0,1,4.56-2,5.79,5.79,0,0,1,2.74.64,6,6,0,0,1,2,1.69,6.83,6.83,0,0,1,1.16,2.41,7.38,7.38,0,0,1,.19,2.81h-9.5Zm6.65-1.87a4.6,4.6,0,0,0-.29-1.3,3.48,3.48,0,0,0-.65-1.09,3.22,3.22,0,0,0-1-.75,3,3,0,0,0-1.31-.29,3.43,3.43,0,0,0-1.36.26,3.11,3.11,0,0,0-1,.73,3.59,3.59,0,0,0-.7,1.09,3.8,3.8,0,0,0-.29,1.35h6.65Z"/><path class="cls-2" d="M273,34.6a2.15,2.15,0,0,0,.95,1.75,3.74,3.74,0,0,0,2,.5,7.66,7.66,0,0,0,.91-0.06,3.94,3.94,0,0,0,1-.24,1.8,1.8,0,0,0,.74-0.51,1.23,1.23,0,0,0,.26-0.89,1.26,1.26,0,0,0-.4-0.9,2.78,2.78,0,0,0-1-.56,9.32,9.32,0,0,0-1.34-.36L274.62,33a14.22,14.22,0,0,1-1.54-.42,4.94,4.94,0,0,1-1.33-.68,3.12,3.12,0,0,1-.94-1.09,3.47,3.47,0,0,1-.35-1.64,2.94,2.94,0,0,1,.51-1.76,3.91,3.91,0,0,1,1.3-1.15,5.66,5.66,0,0,1,1.75-.61,10.32,10.32,0,0,1,1.84-.17,8.42,8.42,0,0,1,1.91.21,5.19,5.19,0,0,1,1.65.69,4,4,0,0,1,1.23,1.24,4.29,4.29,0,0,1,.61,1.84h-3a1.78,1.78,0,0,0-.94-1.37,3.89,3.89,0,0,0-1.69-.35,6.07,6.07,0,0,0-.71,0,3.34,3.34,0,0,0-.78.19,1.64,1.64,0,0,0-.61.4,1,1,0,0,0-.25.69,1.09,1.09,0,0,0,.36.85,2.87,2.87,0,0,0,1,.54,9.29,9.29,0,0,0,1.34.36l1.55,0.33q0.77,0.18,1.53.42a4.93,4.93,0,0,1,1.34.68,3.29,3.29,0,0,1,1,1.07,3.25,3.25,0,0,1,.36,1.6,3.48,3.48,0,0,1-.52,2,4.15,4.15,0,0,1-1.36,1.3,6.19,6.19,0,0,1-1.86.73,9.43,9.43,0,0,1-2,.23,8.82,8.82,0,0,1-2.26-.27,5.27,5.27,0,0,1-1.8-.84,4,4,0,0,1-1.2-1.4,4.45,4.45,0,0,1-.46-2H273Z"/><polygon class="cls-3" points="24.94 41.74 43.06 29.66 43.06 15.16 24.94 15.16 24.94 41.74"/><polygon class="cls-4" points="43.06 41.74 24.94 29.66 24.94 15.16 43.06 15.16 43.06 41.74"/><path class="cls-5" d="M34,12A20,20,0,1,0,54,32,20,20,0,0,0,34,12Zm0,35.1A15.1,15.1,0,1,1,49.1,32,15.1,15.1,0,0,1,34,47.1Z"/><path class="cls-6" d="M45.09,42.23A15.09,15.09,0,0,1,20,26.38L15.8,23.74A20,20,0,0,0,49.29,44.88Z"/></svg>
```.text

// Sanity-check a yyyy-mm-dd date string.
#let _validate-date(value) = {
  if type(value) != str or value.match(regex("^\\d{4}-\\d{2}-\\d{2}$")) == none {
    panic("iacrj: invalid crossmark-date; expected YYYY-MM-DD, got " + repr(value) + ".")
  }
  let (year, month, day) = value.split("-").map(int)
  datetime(year: year, month: month, day: day).display("[year]-[month]-[day]")
}

#let _crossmark-url(doi, date-stamp) = {
  let date-stamp = _validate-date(date-stamp)
  // Encode the DOI as one query parameter, including any reserved characters.
  let data = bytes(doi)
  let encoded = range(data.len()).map(i => {
    let byte = data.at(i)
    let char = str.from-unicode(byte)
    if char in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~" {
      char
    } else {
      let hex = upper(str(byte, base: 16))
      "%" + if hex.len() == 1 { "0" + hex } else { hex }
    }
  }).join()
  "https://crossmark.crossref.org/dialog/?doi=" + encoded + "&domain=pdf&date_stamp=" + date-stamp
}

/// Render the linked Crossmark badge for a DOI and its PDF major-version date.
#let check-for-updates(doi, date-stamp, width: 69pt) = {
  link(_crossmark-url(doi, date-stamp), image(bytes(_crossmark-icon), width: width, alt: "Check for updates", format: "svg"))
}

/// Parses the journal metadata that the publisher supplies for the final
/// version (\jobname.iacrmetadata in iacrj.cls): one `key=value` per line,
/// e.g. "volume=5\nnumber=3". Optional `doi` and `crossmark-date` fields supply
/// final-version links; the date identifies the PDF's last major version.
/// Blank lines and unknown keys are ignored, so
/// the publisher can add keys before the template uses them.
#let _parse-iacrmetadata(text) = {
  let values = (:)
  for line in text.split("\n").map(str.trim).filter(line => line != "") {
    let parts = line.split("=")
    if parts.len() < 2 {
      panic("iacrj: iacrmetadata line \"" + line + "\" is not of the form key=value.")
    }
    values.insert(parts.first().trim(), parts.slice(1).join("=").trim())
  }

  let integer(key) = {
    let value = values.at(key, default: none)
    if value == none { return none }
    if value.match(regex("^\d+$")) == none {
      panic("iacrj: iacrmetadata " + key + " must be a whole number, got \"" + value + "\".")
    }
    int(value)
  }
  let optional(key) = {
    let value = values.at(key, default: none)
    if value == "" { none } else { value }
  }
  let crossmark-date = optional("crossmark-date")
  (
    volume: integer("volume"),
    number: integer("number"),
    doi: optional("doi"),
    crossmark-date: if crossmark-date != none { _validate-date(crossmark-date) },
  )
}

/// Render the publication header: journal, issue, DOI and Crossmark badge.
/// The caller decides whether this header should appear; page counts resolve
/// in context. `journal` is a dictionary with `name` and `issn`.
#let first-page-header(
  journal,
  volume: none,
  number: none,
  doi: none,
  crossmark-date: none,
) = context {
  // Journal name and issue on the left, publication links on the right.
  set text(..config.first-page-header.text)
  set par(leading: config.first-page-header.leading)
  let pages = counter(page).final().first()
  let issue = (
    [ISSN~#journal.issn],
    if volume != none [Vol.~#volume],
    if number != none [No.~#number],
    [#pages~#if pages == 1 [page.] else [pages.]],
  ).filter(x => x != none)
  let cic = journal.issn == config.journals.cic.issn
  let journal-info = {
    journal.name
    linebreak()
    issue.join[, ]
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
  number: none,
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
        number: number,
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

/// Render the title, authors, affiliations, abstract and keywords.
/// Authors and affiliations are the normalized metadata dictionaries used by
/// `iacrj`; the abstract is rendered content, or `none` to omit it.
/// An empty author list renders an anonymous submission and hides affiliations.
/// This function inherits document-wide styling from its caller.
#let title-block(
  title: "",
  authors: (),
  affiliations: (),
  abstract: none,
  keywords: (),
) = {
  let anonymous = authors.len() == 0
  let tb = config.title-block
  let marks(it, raise) = super(..tb.marks, baseline: raise, it)

  // With a single author or a single affiliation the numbers carry no
  // information, so neither the authors nor the affiliations get them.
  let show-inst = authors.len() > 1 and affiliations.len() > 1

  let author-names = if anonymous { ([Anonymous Submission],) } else { authors.map(a => box({
    a.name
    if show-inst and a.inst != none { marks(a.inst.map(str).join(","), tb.authors.mark-raise) }
    if a.footnote != none {
      // Author footnotes are lettered (a, b, ...) and placed like the
      // affiliation marks, so "1,a" reads as one superscript.
      set super(..tb.marks, baseline: tb.authors.mark-raise)
      if show-inst and a.inst != none { super[,] }
      footnote(numbering: "a", a.footnote)
    }
    if a.orcid != none { orcid(a.orcid) }
  })) }
  let affiliation-lines = if anonymous { () } else { affiliations.enumerate().map(((i, aff)) => {
    if show-inst {
      marks(str(i + 1), tb.affiliations.mark-raise)
      [~]
    }
    (aff.department, aff.name, aff.city, aff.country).filter(x => x != none).join(", ")
  }) }
  let emails = if anonymous { () } else {
    authors.filter(a => a.email != none).map(a => a.email + " (" + a.name + ")")
  }

  set par(justify: false, first-line-indent: 0pt)
  // Only the outer blocks use `gap` for spacing. A set rule here would
  // also remove spacing around display equations inside the abstract.
  let block = block.with(spacing: 0pt)
  align(center, {
    v(tb.title.gap)
    block({
      set par(leading: tb.title.leading)
      // The emails footnote has no marker. Footnotes are listed in document
      // order, so placing it at the title puts it before the author footnotes.
      if emails.len() > 0 {
        let label = if emails.len() == 1 { "Email: " } else { "Emails: " }
        footnote(numbering: n => none, label + emails.join(", "))
        counter(footnote).update(0) // so author footnotes start at a
      }
      text(..tb.title.text, title)
    })
    v(tb.authors.gap)
    block({
      set par(leading: tb.authors.leading)
      text(..tb.authors.text, author-names.join(", ", last: " and "))
    })
    if affiliation-lines.len() > 0 {
      v(tb.affiliations.gap)
      block({
        set text(..tb.affiliations.text)
        set par(leading: tb.affiliations.leading)
        affiliation-lines.join(linebreak())
      })
    }
  })
  if abstract != none {
    v(tb.abstract.gap)
    block({
      set text(..tb.abstract.text)
      set par(..tb.abstract.par)
      align(center, strong[Abstract])
      v(tb.abstract.heading-gap)
      pad(x: tb.abstract.margin, abstract)
    })
  }
  if keywords.len() > 0 {
    v(tb.keywords.gap)
    block[#text(..tb.keywords.label)[Keywords:]~#keywords.join(", ")]
  }
  // Author and email footnotes don't count: the paper's first footnote is 1.
  counter(footnote).update(0)
}

// The template itself. `iacrmetadata` is the text of main.iacrmetadata;
// authors use `iacrj` below, which takes it from the compiler instead.
#let _iacrj(
  iacrmetadata: "",
  journal: none, // required: "cic", "tosc" or "tches"
  version: "preprint",
  notanonymous: false,
  title: "",
  authors: (),
  affiliations: (),
  abstract: "",
  keywords: (),
  enable-checks: true,
  body,
) = {
  let from-string = (self, it) => if type(it) == str { (name: it) } else { it }
  let parsing = (
    // \addauthor: (name: .., inst: 1 or (1, 2), orcid: .., email: ..)
    author: z.dictionary(
      (
        name: z.string(min: 1),
        surname: z.string(min:1, optional: true),
        footnote: z.string(min:1, optional:true),
        inst: z.array(z.integer(), optional: true, pre-transform: (self, it) => if type(it) == int { (it,) } else { it }),
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

  let args = z.parse(
    (
      journal: journal,
      version: version,
      notanonymous: notanonymous,
      title: title,
      authors: authors,
      affiliations: affiliations,
      abstract: abstract,
      keywords: keywords,
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
      // Either "Title" or (full: "Long Title", short: "Short Title").
      // The short title is used in the running head (\titlerunning).
      // A plain string is turned into (full: it, short: it) before validation.
      title: z.dictionary(
        (full: z.string(min: 1), short: z.string(min: 1)),
        pre-transform: (self, it) => if type(it) == str { (full: it, short: it) } else { it },
      ),
      authors: z.array(parsing.author, min: 1),
      affiliations: z.array(parsing.affiliation),
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
          if type(it) == str { (content: eval(it, mode: "markup"), text: it) } else { it }
        },
      ),
      keywords: z.array(z.string()),
    )),
    scope: ("iacrj",),
    ctx: z.z-ctx(strict: true), // reject unknown keys, e.g. (full: .., shrot: ..)
  )

  // Volume and number for the first-page header (\IACR@vol, \IACR@no).
  let iacr = _parse-iacrmetadata(iacrmetadata)

  let (full: full-title, short: short-title) = args.title
  let config = config
  let journal = config.journals.at(args.journal)

  // A submission hides the authors and affiliations everywhere: title block,
  // running head, PDF metadata and bundle metadata (iacrj.cls's anonymous mode).
  let anonymous = args.version == "submission" and not args.notanonymous
  let author-names = args.authors.map(a => a.name)

  config.document = (
    title: [#full-title],
    author: if anonymous { ("hidden for submission",) } else { author-names },
    description: if args.version == "final" {
      [#(journal.name + if iacr.doi != none { ", DOI: " + iacr.doi } else { "" })]
    },
  )
  config.page.header = page-header(
    journal,
    title: short-title,
    authors: if anonymous { () } else { args.authors },
    version: args.version,
    volume: iacr.volume,
    number: iacr.number,
    doi: iacr.doi,
    crossmark-date: iacr.crossmark-date,
  )


  let check(elem, config) = {
    let name = repr(elem)
    let get(key) = eval("e => e." + key)(elem)
    let changed = config.keys().filter(k => get(k) != config.at(k))
    if changed == () { return }

    let describe(k) = {
      let field = "`" + name + "." + k + "`"
      if type(config.at(k)) == content {
        // e.g. the header: printing the content itself isn't helpful
        field + " was changed"
      } else {
        field + " is " + repr(get(k)) + ", but the template requires " + repr(config.at(k))
      }
    }

    panic(
      "The iacrj template does not allow changing these settings:\n"
        + changed.map(k => "  - " + describe(k)).join("\n")
        + "\nRemove the `set " + name + "(...)` rules that change them.",
    )
  }

  let config-checks() = context {
    check(
      text,
      if text.font == config.raw.font { config.text + (font: config.raw.font) } else { config.text }
    )
    check(page, config.page)
    check(document, config.document)
    check(par, config.par)
  }

  set document(..config.document)
  set page(..config.page)
  set text(..config.text)
  set par(..config.par)

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
    text(..config.caption-label)[#it.supplement~#it.counter.display(it.numbering)#it.separator]
    it.body
  }

  set footnote.entry(..config.footnote.entry)
  show footnote.entry: set text(..config.footnote.text)
  show footnote.entry: set par(..config.footnote.par)

  show link: it => if type(it.dest) == str { text(fill: config.colors.url, it) } else { it }
  show ref: set text(fill: config.colors.link)
  show cite: set text(fill: config.colors.cite)
  show outline.entry: set text(fill: config.colors.link)


  let meta = (
    journal: args.journal,
    version: args.version,
    volume: iacr.volume,
    number: iacr.number,
    title: (full: full-title, short: short-title),
    authors: if anonymous { () } else { args.authors },
  )
  if args.version == "final" {
    meta.doi = iacr.doi
    meta.crossmark-date = iacr.crossmark-date
    meta.crossmark-url = if iacr.doi != none and iacr.crossmark-date != none {
      _crossmark-url(iacr.doi, iacr.crossmark-date)
    }
  }
  let abstract-text = args.abstract.text


  let front-matter = title-block(
    title: full-title,
    authors: if anonymous { () } else { args.authors },
    affiliations: if anonymous { () } else { args.affiliations },
    abstract: if args.abstract.text != "" { args.abstract.content },
    keywords: args.keywords,
  )

  let doc = {
    front-matter

    // The title-block customizes spacing, so should not be checked
    if enable-checks {
      show par: it => { config-checks(); it }
      body
    } else {
      body
    }
  }

  context {
    if target() != "bundle" {
      // regular PDF (or HTML, PNG, SVG) output
      return doc
    }
    // bundle: the paper plus a metadata file
    // the metadata is not exactly yaml, should either build new encoder or change output format.
    document("main.pdf", doc)
    asset("main.meta", yaml.encode(meta))
    asset("main.abstract", abstract-text)
  }
}

/// The iacrj template. The publisher supplies journal metadata (volume,
/// number, doi and crossmark-date) for the final version on the command line, like the
/// \jobname.iacrmetadata file that iacrj.cls reads:
///
///   typst compile --input iacrmetadata="$(cat main.iacrmetadata)" main.typ
///
/// Authors cannot set these values in the document.
#let iacrj(..args) = {
  assert(
    "iacrmetadata" not in args.named(),
    message: "iacrj: the journal metadata is supplied by the publisher, not the document.",
  )
  _iacrj(iacrmetadata: sys.inputs.at("iacrmetadata", default: ""), ..args)
}
