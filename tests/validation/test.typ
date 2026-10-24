// Argument validation of iacrj(). The template panics while parsing its
// arguments, before any layout, so `catch` sees the message.
#import "/src/iacrj.typ": iacrj

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
