This sample illustrates a Typst template for IACR journal articles, with
structured front matter, linked affiliations, ORCID records, and alphanumeric
citations. It also demonstrates accessible mathematical content. For a sequence
of real numbers, consider the partial sum

#math.equation(
  block: true,
  alt: "The sum, for i from one to n, of x sub i squared divided by two.",
  $sum_(i=1)^n x_i^2 / 2.$,
)

The template preserves this abstract's source for the publishing pipeline while
rendering its text and display equation in the paper. Separate metadata controls
anonymous submissions and the final publication header.
