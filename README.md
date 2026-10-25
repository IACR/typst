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

## Final-version DOI and update badge

The publisher supplies publication links through the `iacrmetadata` input,
not through author-facing template arguments. For example, a metadata file can
contain:

```text
volume=3
number=2
doi=10.62056/a66c0l2hd
crossmark-date=2026-07-24

```

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
