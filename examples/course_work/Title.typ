#import "lib/stp2024.typ"
#show: stp2024.template

#let CHANGE_ME(arg) = {
  text(fill:red, arg)
}

#align(center)[
  Министерство образования Республики Беларусь
  #v(1.15em)
  Учреждение образования
  #v(1.15em)
  БЕЛОРУССКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ \ ИНФОРМАТИКИ И РАДИОЭЛЕКТРОНИКИ
  #v(1.15em)
]

#align(left)[
  Факультет #CHANGE_ME([Lorem ipsum])
  #v(1.15em)
  Кафедра #CHANGE_ME([Lorem ipsum])
  #v(1.15em)
  Дисциплина  #CHANGE_ME([Lorem ipsum dolor sit amet])
]


#v(1fr)
#v(4em)

#align(center)[
  ПОЯСНИТЕЛЬНАЯ ЗАПИСКА

  к курсовому проекту

  на тему
  #v(1.15em)
  
  #upper(
    [*#CHANGE_ME([Lorem ipsum dolor sit amet])*]
  )
  #v(1.15em)
  БГУИР КП #CHANGE_ME([6-05-0612-02 0XX]) ПЗ
]

#v(1fr)

#grid(
  columns: (1fr, 1fr),
  align: top,
  [
     Студент
    #v(1.15em)
     Руководитель
    #v(1.15em)
     Нормоконтроллёр
  ],
  [
    #CHANGE_ME([L. L. Lorem])
    #v(1.15em)
    #CHANGE_ME([L. L. Ipsum])
    #v(1.15em)
    #CHANGE_ME([L. L. Dolor])
  ]
)

#v(1fr)

#align(center)[
  Минск #CHANGE_ME([2026])
]
