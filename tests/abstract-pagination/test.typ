// A long abstract must remain breakable rather than becoming a stack child.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(
  journal: "cic",
  title: "A long abstract",
  authors: ("Alice",),
  abstract: ```typ
    Beginning.#metadata("abstract-start")

    #lorem(1800)

    End.#metadata("abstract-end")
  ```.text,
)

#context {
  let start = query(metadata.where(value: "abstract-start"))
    .first()
    .location()
    .page()
  let end = query(metadata.where(value: "abstract-end"))
    .first()
    .location()
    .page()
  assert(
    end > start,
    message: "The abstract must be able to span multiple pages.",
  )
}

Body.
