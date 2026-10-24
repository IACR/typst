// Argument validation of iacrj(). The template panics while parsing its
// arguments, before any layout, so `catch` sees the message.
#import "/src/iacrj.typ": iacrj

#let error(..args) = catch(() => iacrj(..args)[Body])

// Valid minimal calls.
#iacrj(title: "T", authors: ("A",))[]
#iacrj(title: (full: "Long Title", short: "Short"), authors: ((name: "A", inst: (1, 2)),))[]

// At least one author is required.
#assert(error(title: "T", authors: ()).contains("iacrj.authors"))

// An empty title is rejected.
#assert(error(title: "", authors: ("A",)).contains("iacrj.title"))

// Unknown keys are rejected (strict mode), e.g. a misspelled field.
#assert(error(title: (full: "T", shrot: "S"), authors: ("A",)).contains("shrot"))
#assert(error(title: "T", authors: ((name: "A", affiliation: 1),)).contains("affiliation"))

// The abstract must be markup source, not content.
#assert(error(title: "T", authors: ("A",), abstract: [x]).contains("read(\"abstract.typ\")"))
