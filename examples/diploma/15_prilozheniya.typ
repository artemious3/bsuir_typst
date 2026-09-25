#import "lib/stp2024.typ"
 // Применить стиль оформления по СТП
#show: stp2024.template
#let CHANGE_ME(arg) = {
  text(fill:red, arg)
}


#stp2024.appendix(type:[обязательное], title:[Крутой код])[


  #stp2024.listing_diploma[Код, кодирующий кодовые коды][
```
function code(): number {
  return 0xCODE;
}
```
]
]

#stp2024.appendix(type:[обязательное], title:[Результаты проверки на заимствования])[
#figure(
  image(
    width:100%,
    "img/antiplagiat.png"
  )
)

]

#pagebreak()

#CHANGE_ME[ТУТ ВЕДОМОСТЬ]