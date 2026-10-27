// The template does not fix the language: English is only Typst's default,
// and authors can mark text in, or write the whole paper in, another language.
#import "/src/iacrj.typ": iacrj

#show: iacrj.with(journal: "cic", title: "Languages", authors: ("Alice",))

#context assert.eq(text.lang, "en")

#text(lang: "nl")[
  Een Nederlandse zin. #context assert.eq(text.lang, "nl")
]

#set text(lang: "de")

Ein deutscher Absatz. #context assert.eq(text.lang, "de")
