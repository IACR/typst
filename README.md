# The typst template for IACR journals

This is a work in progress while we investigate the feasibility of
supporting typst for IACR journals. It cannot be used for submissions
yet. It is based on the LaTeX `iacrj.cls` along with the companion
`metacapture.sty` for metadata capture.

## Package contents

This package contains several files, including the `iacrj.typ` template,
a sample starter file `example.typ`, and documentation.

## First steps

If you are running typst locally on your own machine, then you will
need to install the typst compiler and the "new computer modern"
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
