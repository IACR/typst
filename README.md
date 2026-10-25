# The typst template for IACR journals

This is a work in progress while we investigate the feasibility of
supporting typst for IACR journals. It cannot be used for submissions
yet. It is based on the LaTeX `iacrj.cls` along with the companion
`metacapture.sty` for metadata capture.

## Package contents

This package contains several files, including the `iacrj.typ` template,
some documentation, and eventually a sample starter file.

## First steps

If you are running typst locally on your own machine, then you will
need to install the typst compiler and the "New Computer Modern"
fonts. You can first check if the New Computer Modern fonts are
installed by inspecting `typst fonts`. If you don't already have them
installed, then you can download these from
[CTAN](https://ctan.org/pkg/newcomputermodern) using the link
"Download the contents of this package in one zip archive".  In order
to install these on an Ubuntu system, save this as
`newcomputermodern.zip` and then follow the instructions:
```
mkdir -p ~/.local/share/fonts/NewComputerModern
pushd ~/.local/share/fonts/NewComputerModern
unzip ~/Downloads/newcomputermodern.zip
```

## Authors and affiliations

Affiliations are an ordered dictionary with short keys. Authors refer to these
keys using `inst`, either as a single string or a tuple of strings:

```typ
#show: iacrj.with(
  journal: "cic",
  title: "Example paper",
  authors: (
    (name: "Alice", inst: "uni-a"),
    (name: "Bob", inst: ("uni-a", "uni-b")),
  ),
  affiliations: (
    uni-a: (name: "University A", city: "City A"),
    uni-b: (name: "University B"),
  ),
)
```

The keys are not printed. Dictionary insertion order determines both the
superscript numbers and the order of displayed affiliations; changing that order
automatically updates the numbers without changing author references. Author-side
numbers link to their corresponding affiliation entries. As before, numbers are
omitted with a single author or a single affiliation.

A string value such as `uni-a: "University A"` is shorthand for a record with
only a `name`. Every referenced key must exist. Affiliation arrays and numeric
`inst` references are no longer accepted. Anonymous submissions omit authors
and affiliations from both the front matter and bundle metadata.

## Bibliography

Pass one BibTeX filename or a tuple of filenames to the template:

```typ
#show: iacrj.with(
  journal: "cic",
  title: "Example paper",
  authors: ("Alice",),
  bibliography: ("references/strings.bib", "references/works.bib"),
)

A citation to @example.
```

Paths are relative to the Typst project root, with an optional leading `/`,
not to the template or the calling file. The template reads and concatenates
these files in the supplied order, then passes the combined bytes to Typst's
native bibliography function. This lets BibTeX string aliases defined in one
file be used in another. A References section is appended automatically; do not
add a separate `#bibliography(...)` call. Manual calls are rejected with a
message directing you to the template's `bibliography:` option, even with
`enable-checks: false`. The small `src/iacrj.csl` style
approximates the LaTeX class's `alphaurl` style: matching bracketed alphanumeric
labels in citations and the reference list, author-sorted entries, and DOI/URL
information. It uses Typst's native bibliography rendering; the two styles are
not identical. Typst's built-in `alphanumeric` style supports citations only,
so it cannot render the reference list on its own. The template fixes the
bibliography style and requires citations to inherit it; changing either with
set rules or explicit element arguments is rejected when checks are enabled.
Omitting the option (or supplying `()`) adds no bibliography.

The supplied filenames are recorded in the [bundle metadata](#bundle-output).
The source files and combined bibliography are not exported as bundle assets;
how the publishing pipeline retrieves those files is still unresolved.

## Bundle output

Bundle export produces the PDF and accompanying machine-readable metadata in
one output directory. From the repository root, try the included example:

```sh
typst compile --features bundle --format bundle src/example.typ example-bundle
```

Typst uses `src/` as the project root for this command, matching the example's
bibliography paths. For your own paper, replace the input and output paths and
set `--root` if needed. Typst's bundle export is experimental, requires the
`bundle` feature flag, and is currently available only in the CLI. Its behavior
and this template's metadata format may change; this is not yet a finalized
journal submission format.

The output filenames are fixed, independently of the input filename:

| File | Contents |
| --- | --- |
| `main.pdf` | The formatted paper, including the automatically appended bibliography when configured. |
| `main.meta` | UTF-8 metadata serialized using Typst's `yaml.encode`, with the fields below. |
| `main.abstract` | The abstract's original Typst markup string, not extracted PDF text or a rendered abstract. Empty when no abstract is supplied. |

`main.meta` currently contains:

| Field | Meaning |
| --- | --- |
| `journal`, `version` | The selected journal and document version. |
| `volume`, `number` | Journal issue metadata supplied by the publisher, or the template defaults. |
| `title` | A record with `full` and `short` title strings. |
| `authors` | Validated author records, including affiliation keys in `inst`. |
| `affiliations` | Validated affiliation records keyed by the supplied identifiers, in display order. |
| `bibliography` | The supplied BibTeX filenames, normalized to a list and kept in input order. Empty when no sources are configured. |
| `keywords` | The supplied keywords, as a list. |
| `pages` | The number of physical pages through the end of the paper, excluding bibliography-only pages. |
| `doi`, `crossmark-date`, `crossmark-url` | Present only for `version: "final"`. Unavailable values are null; the Crossmark URL requires both a DOI and a Crossmark date. |

The `pages` count includes front matter. A page shared by the paper and its
bibliography counts as a paper page. This uses physical page positions, not the
page counter or displayed page numbers; without a bibliography it is the paper's
total page count.

Anonymous submissions have an empty author list and affiliation dictionary in
`main.meta`; `notanonymous: true` disables that redaction. The abstract is
preserved verbatim, so authors must remove identifying information from it and
from the paper's prose themselves.

The bundle does **not** include the Typst source files, original BibTeX files,
or concatenated bibliography data. It is therefore not a self-contained source
archive. Delivery of the referenced BibTeX files to the publishing pipeline is
still unresolved. Ordinary PDF compilation does not emit the metadata sidecars.

### Querying the metadata

The same record is available without bundle export: the template places it in
the document as a `metadata` element labeled `<iacrj-meta>`, so `typst eval`
can extract it as JSON (or YAML with `--format yaml`):

```sh
typst eval --in src/example.typ 'query(<iacrj-meta>).first().value' --pretty
typst eval --in src/example.typ 'query(<iacrj-meta>).first().value.title.full'
```

It has the fields of `main.meta` plus `abstract`, the abstract's Typst markup
string. `pages` is null for HTML output.

## Development escape hatch

Style checks are enabled by default. If they obstruct development or debugging,
you can temporarily add `enable-checks: false` to the template options:

```typ
#show: iacrj.with(
  journal: "cic",
  title: "Work in progress",
  authors: ("Alice",),
  enable-checks: false,
)
```

This disables style checks, not the template's default formatting or metadata
validation. Manual `bibliography(...)` calls remain prohibited; supply files
through the `bibliography:` option. Restore `enable-checks: true`, or remove the
option, before submission. This is a development aid, not permission to change
the journal's required style.

## Final-version DOI and update badge

The publisher supplies publication links in a metadata file named by the
`iacrmetadata` input, not through author-facing template arguments. For example,
a metadata file can contain:

```text
volume=3
number=2
doi=10.62056/a66c0l2hd
crossmark-date=2026-07-24

```

Name the file relative to the project root (`src/` for the included example):

```sh
typst compile --input iacrmetadata=main.iacrmetadata src/example.typ
```

Without the input, the paper compiles without a volume, number, DOI or badge.
Typst cannot test whether a file exists, so a named file that is missing is a
compilation error. Each line is `key=value`; blank lines and unknown keys are
ignored, but a repeated key, a quoted value, a non-numeric volume or number, or
a malformed DOI or date stops compilation with an error.

Use the DOI identifier, not its `https://doi.org/` URL. In `version: "final"`,
the DOI appears in the first-page header and PDF description (subject), and the
DOI, Crossmark date, and update URL are included in the bundle metadata. Preprints and submissions
do not expose these publication links.

For CiC, the DOI URL is right-aligned above the linked “Check for updates” badge,
as in the LaTeX class. ToSC and TCHES instead show `DOI: ...` on the issue line,
without a badge. The badge SVG is stored in `_crossmark-icon` in `src/iacrj.typ`;
`check-for-updates` renders it at 69pt wide by default. The badge's Crossmark
URL is derived automatically from the DOI and `crossmark-date`; no separate
URL is supplied. `crossmark-date` must use the exact `YYYY-MM-DD` format,
including zero-padded month and day, and represent a valid calendar date. It identifies
the PDF's last major version—normally its publication date, or the date of a
significant in-place correction. It is never inferred from the compilation date.
Without it, the DOI link is still rendered but the Crossmark badge is omitted.

## Accessibility

The template uses native Typst elements for the visible document title, abstract
heading, section headings, figures, captions, lists, and footnotes. Document
metadata includes the title, authors, and keywords. Author ORCID links have
person-specific alternative descriptions. Styling these elements does not remove
their semantics.

For accessible output, keep using native elements in the paper itself. Supply
alternative descriptions for meaningful images and mathematics, and use
`table.header` for table headings. Typst's
[accessibility guide](https://typst.app/docs/guides/accessibility/) describes the
remaining author responsibilities.

The semantic regression fixture can also be checked with stricter export rules:

```sh
typst compile --root . --pdf-standard ua-1,a-2a tests/accessibility/test.typ accessibility.pdf
```

## Dependencies

* **Typst** and the **New Computer Modern** fonts, as described above.
* The **[valkyrie](https://typst.app/universe/package/valkyrie)** package,
  which the template uses to check its arguments. Typst downloads it
  automatically the first time you compile, so there is nothing to install.
* **[tytanic](https://github.com/typst-community/tytanic)** (the `tt`
  command), which is only needed to run the tests in `tests/`, not to use
  the template. Use a release that is built with the same Typst version
  that you use; `tt util about` shows it (tytanic 0.4.1 has Typst 0.15.1).

### Installing tytanic

The simplest way is to download a prebuilt binary from the
[releases page](https://github.com/typst-community/tytanic/releases).
For example, on x86-64 Linux:
```
curl -LO https://github.com/typst-community/tytanic/releases/download/v0.4.1/tytanic-x86_64-unknown-linux-musl.tar.xz
tar xJf tytanic-x86_64-unknown-linux-musl.tar.xz
install -m755 tytanic-x86_64-unknown-linux-musl/tt ~/.local/bin/tt
tt --version
```
On other systems, pick the matching file from the releases page (for
example `aarch64-apple-darwin` for an Apple Silicon Mac), and make sure
the directory you put `tt` in is on your `PATH`.

Alternatively, build it from source with Cargo. Version 0.4.1 needs Rust
1.95 or newer, so update Rust first with `rustup update` if necessary:
```
cargo install --locked tytanic
```

## Formatting

All `.typ` files use **typstyle 0.15.2** with its default settings (80 columns,
two-space indentation). Install it with:

```sh
cargo install --locked typstyle --version 0.15.2
```

From the repository root, format or check the sources and test fixtures with:

```sh
typstyle --inplace src tests
typstyle --check src tests
```

CI runs the same formatting check independently of the test suite.

### Jujutsu integration

jj does not use Git pre-commit hooks. Configure its native `jj fix` integration
once per clone:

```sh
jj config set --repo fix.tools.typstyle.command '["typstyle"]'
jj config set --repo fix.tools.typstyle.patterns '["glob:**/*.typ"]'
jj config set --repo aliases.fmt '["fix", "--source", "@", "--include-unchanged-files"]'
```

Then run `jj fmt` before finalizing a change. It formats all matching files in
the working-copy change and its descendants, without rewriting its ancestors.
This is an explicit command, not an automatic hook; CI rejects unformatted
changes. Avoid bare `jj fix` unless you intend to format the broader mutable
history selected by jj's defaults.

## Running the tests

From anywhere in the repository, run
```
tt run --use-system-fonts
```
`--use-system-fonts` is needed because tytanic otherwise only sees the fonts
embedded in Typst, which don't include New Computer Modern Sans and Mono.
By default tytanic stops at the first failing test; add `--no-fail-fast`
to run all of them.

Each test is a directory with a `test.typ`:
* A test with a `ref/` directory compares its pages with the reference
  images in `ref/`. After an intended change in the output, check the new
  images in the test's `out/` directory, then regenerate the references with
  `tt update --use-system-fonts`. Small differences in installed font
  versions can make these tests fail on another machine; regenerate the
  references there if so.
* A test without `ref/` only has to compile. These use `assert` together
  with tytanic's `catch` to check error messages.

Create a new test with `tt new <name>` (add `-C` for a compile-only test).

Layout-time style-check failures require a separate compiler invocation, since
`catch` only catches evaluation-time errors. Run their regression checks with:

```sh
python3 tests/style-checks/check.py
```

These checks require the `typst` CLI and the same fonts as the main suite, and
also run in CI. They verify that template-owned set-rule changes and explicit
citation style overrides are rejected, and that the existing
`enable-checks: false` escape hatch still works for style checks. Manual
bibliography calls are rejected independently of that switch, whether or not
sources were supplied through the template option. The checks are diagnostics,
not a security boundary: arbitrary replacement show rules can bypass them.
