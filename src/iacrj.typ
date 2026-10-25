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
    first-page-header: (text: (size: 9pt), leading: 4.7pt, dy: 8.5pt),
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
        heading-gap: 9.6pt,
        text: (size: 9pt),
        par: (leading: 4.7pt, spacing: 4.7pt, justify: true, first-line-indent: (amount: 1.5em, all: true)),
        margin: 25pt,
      ),
      // \textbf{\textsf{Keywords:}}~
      keywords: (gap: 12.2pt, label: (font: sans, weight: "bold")),
    ),
  )

// Downloaded from https://info.orcid.org/documentation/integration-guide/orcid-id-display-guidelines/
#let _orcid-icon = image(
  bytes(```
<svg width="32" height="32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M32 16c0 8.837-7.163 16-16 16-8.838 0-16-7.163-16-16C0 7.162 7.162 0 16 0c8.837 0 16 7.162 16 16Z" fill="#A6CE39"/>
  <path fill-rule="evenodd" clip-rule="evenodd" d="M18.813 9.637h-5.45v13.9h5.474c4.555 0 7.35-3.378 7.35-6.95 0-1.635-.562-3.372-1.77-4.704-1.215-1.336-3.065-2.246-5.605-2.246ZM18.6 21.3h-2.813v-9.425H18.5c1.823 0 3.12.552 3.96 1.4.842.849 1.252 2.021 1.252 3.312 0 .784-.239 1.967-.993 2.948-.745.969-2.01 1.765-4.119 1.765Zm5.311-4.026c-.251 1.74-1.494 4.276-5.311 4.276h-3.063H18.6c3.817 0 5.06-2.536 5.311-4.276Zm1.812-2.405c-.657-2.601-2.85-4.982-6.91-4.982h-5.2 5.2c4.06 0 6.253 2.38 6.91 4.982Zm.215 1.718ZM8.363 9.675v13.887h2.425V9.675H8.363Zm2.175 13.637H8.612h1.925ZM9.575 8.65c.84 0 1.513-.689 1.513-1.513 0-.823-.673-1.512-1.513-1.512-.838 0-1.512.674-1.512 1.513 0 .823.672 1.512 1.512 1.512Z" fill="#fff"/>
</svg>
  ```.text),
  width: 0.8em,
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
/// metacapture.sty (used by iacrj.cls): the "authenticated" logo, 0.8em wide,
/// sitting on the baseline, directly after the author name and affiliation marks.
///
/// Accepts e.g. "0000-0002-1825-0097", "0000 0002 1825 0097",
/// "0000000218250097", "https://orcid.org/0000-0002-1825-0097",
/// "orcid.org/0000-0002-1825-009x". Panics on malformed IDs and wrong checksums.
#let orcid(id) = {
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

  link("https://orcid.org/" + formatted, box(_orcid-icon))
}

/// Parses the journal metadata that the publisher supplies for the final
/// version (\jobname.iacrmetadata in iacrj.cls): one `key=value` per line,
/// e.g. "volume=5\nnumber=3". Blank lines and unknown keys are ignored, so
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
  (volume: integer("volume"), number: integer("number"))
}

/// Render the first-page journal header and subsequent running heads.
/// `journal` is a dictionary with `name` and `issn`; authors are normalized
/// metadata dictionaries. An empty author list produces an anonymous running head.
#let page-header(
  journal,
  title: "",
  authors: (),
  version: "preprint",
  volume: none,
  number: none,
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
      // Journal name and issue on the left. The header ends at the baseline
      // of its last line, like the running head.
      set text(..config.first-page-header.text)
      set par(leading: config.first-page-header.leading)
      let pages = counter(page).final().first()
      let issue = (
        [ISSN~#journal.issn],
        if volume != none [Vol.~#volume],
        if number != none [No.~#number],
        [#pages~#if pages == 1 [page.] else [pages.]],
      ).filter(x => x != none)
      move(dy: config.first-page-header.dy, {
        journal.name
        linebreak()
        issue.join[, ]
      })
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
    if a.orcid != none { [ #orcid(a.orcid)] }
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
      // The parbreak makes a one-paragraph abstract a real paragraph, so it
      // gets the first-line indent too.
      pad(x: tb.abstract.margin, { abstract; parbreak() })
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
  )
  config.page.header = page-header(
    journal,
    title: short-title,
    authors: if anonymous { () } else { args.authors },
    version: args.version,
    volume: iacr.volume,
    number: iacr.number,
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

/// The iacrj template. The publisher supplies the journal metadata (volume,
/// number) for the final version on the command line, like the
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
