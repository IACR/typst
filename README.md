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
