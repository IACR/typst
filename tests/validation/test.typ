// Argument validation of iacrj(). The template panics while parsing its
// arguments, before any layout, so `catch` sees the message.
#import "/src/iacrj.typ": iacrj, _parse-iacrmetadata

#let error(..args) = catch(() => iacrj(..args)[Body])

// Valid minimal calls.
#iacrj(journal: "cic", title: "T", authors: ("A",))[]
#iacrj(journal: "cic", title: (full: "Long Title", short: "Short"), authors: ((name: "A", inst: (1, 2)),))[]

// At least one author is required.
#assert(error(journal: "cic", title: "T", authors: ()).contains("iacrj.authors"))

// An empty title is rejected.
#assert(error(journal: "cic", title: "", authors: ("A",)).contains("iacrj.title"))

// Unknown keys are rejected (strict mode), e.g. a misspelled field.
#assert(error(journal: "cic", title: (full: "T", shrot: "S"), authors: ("A",)).contains("shrot"))
#assert(error(journal: "cic", title: "T", authors: ((name: "A", affiliation: 1),)).contains("affiliation"))

// The abstract must be markup source, not content.
#assert(error(journal: "cic", title: "T", authors: ("A",), abstract: [x]).contains("read(\"abstract.typ\")"))

// The journal is required and is one of cic, tosc and tches.
#assert(error(title: "T", authors: ("A",)).contains("`journal` is required"))
#iacrj(journal: "tosc", title: "T", authors: ("A",))[]
#iacrj(journal: "tches", title: "T", authors: ("A",))[]
#assert(error(journal: "eprint", title: "T", authors: ("A",)).contains("iacrj.journal"))

// The version is one of preprint (the default), submission and final.
#iacrj(journal: "cic", version: "submission", title: "T", authors: ("A",))[]
#iacrj(journal: "cic", version: "final", title: "T", authors: ("A",))[]
#assert(error(journal: "cic", version: "draft", title: "T", authors: ("A",)).contains("iacrj.version"))

// A submission hides the authors unless notanonymous is set.
#iacrj(journal: "cic", version: "submission", title: "T", authors: ("Alice",))[
  #context assert.eq(document.author, ("hidden for submission",))
]
#iacrj(journal: "cic", version: "submission", notanonymous: true, title: "T", authors: ("Alice",))[
  #context assert.eq(document.author, ("Alice",))
]
#assert(error(journal: "cic", notanonymous: "yes", title: "T", authors: ("A",)).contains("iacrj.notanonymous"))

// Volume and number come from the publisher's iacrmetadata, never from the
// document.
#assert(error(journal: "cic", title: "T", authors: ("A",), volume: 5).contains("volume"))
#assert(error(journal: "cic", title: "T", authors: ("A",), iacrmetadata: "volume=5").contains("publisher"))
#assert.eq(_parse-iacrmetadata(""), (volume: none, number: none))
#assert.eq(_parse-iacrmetadata("volume=5\nnumber=3\n"), (volume: 5, number: 3))
#assert.eq(_parse-iacrmetadata(" volume = 5 \n\ndoi=10.62056/a1b2=c\n"), (volume: 5, number: none))
#assert(catch(() => _parse-iacrmetadata("volume=five")).contains("whole number"))
#assert(catch(() => _parse-iacrmetadata("volume 5")).contains("key=value"))
