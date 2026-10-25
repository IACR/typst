// Keys identify affiliations; insertion order, not key sorting, sets the numbers.
#import "/src/iacrj.typ": affiliation-marker, affiliation-reference, iacrj

#assert.eq(affiliation-marker(2).body, [2])

#assert.eq(affiliation-reference("uni-a", 2).dest, <iacrj-affiliation-uni-a>)

#show: iacrj.with(
  journal: "cic",
  title: "Keyed affiliations",
  authors: (
    (name: "Alice", inst: ("uni-a", "uni-b")),
    (name: "Bob", inst: "uni-b"),
  ),
  affiliations: (
    uni-b: (name: "University B", city: "City B"),
    uni-a: "University A",
  ),
)

Body.

#context {
  let links = query(link)
  assert.eq(links.map(it => it.dest), (
    <iacrj-affiliation-uni-a>,
    <iacrj-affiliation-uni-b>,
    <iacrj-affiliation-uni-b>,
  ))
  // Alice's first key is second in the dictionary, so her markers read 2,1.
  assert.eq(links.map(it => it.body.body), ([2], [1], [1]))
  let first = query(<iacrj-affiliation-uni-b>).first()
  let second = query(<iacrj-affiliation-uni-a>).first()
  assert.eq(first.body, [1])
  assert.eq(second.body, [2])
  assert(first.location().position().y < second.location().position().y)
  for reference in links {
    let target = query(reference.dest)
    assert.eq(target.len(), 1)
    assert(
      target.first().location().position().y
        > reference.location().position().y,
    )
  }
}
