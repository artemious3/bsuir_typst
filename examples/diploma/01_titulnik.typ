#import "lib/stp2024.typ"
#show: stp2024.template

#let CHANGE_ME(arg) = {
  text(fill:red, arg)
}

#align(center)[
  Министерство образования Республики Беларусь
  #v(1.15em)
  Учреждение образования

  БЕЛОРУССКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ \ ИНФОРМАТИКИ И РАДИОЭЛЕКТРОНИКИ
]

#align(left)[
\  Факультет #"  " #CHANGE_ME[компьютерных систем и сетей]

\  Кафедра #"     " #CHANGE_ME[программного обеспечения информационных технологий]
  #v(1.15em)
]

#align(right)[ #block[
  #set align(left)
  _К защите допустить:_

  Заведующий кафедрой #CHANGE_ME[КАФЕДРА]

  \_\_\_\_\_\_\_\_\_\_\_\_ #CHANGE_ME[И. Иванов]
]]

#v(3em)

#align(center)[
  ПОЯСНИТЕЛЬНАЯ ЗАПИСКА

  дипломного проекта

  на тему
  #v(1.15em)

  #upper(
    CHANGE_ME(
    [*Тема \ Диплома \ Длинная*]
    )
  )
  #v(1.15em)
  #CHANGE_ME[БГУИР ДП 1-40 01 01 01 100 ПЗ]
]

#v(1.75em)

#grid(
  columns: (2.8fr, 1fr),
  align: top,
  [
    \ Студент
    #v(-0.3em)
    \ Руководитель
    #v(-0.3em)
    \ Консультанты:
    #v(-0.3em)
    \ #"     " _от кафедры #CHANGE_ME[ПОИТ]_
    #v(-0.3em)
    \ #"     " _по экономическому разделу_
    #v(-0.4em)
    \ Нормоконтроллёр
    #v(-0.3em)
    \ Рецензент
  ],
  [
    \ #CHANGE_ME[А. А. Студент]
    #v(-0.3em)
    \ #CHANGE_ME[А. А. Иванов]
    #v(-0.3em)
    \ #" "
    #v(-0.3em)
    \ #CHANGE_ME[А. А. Иванов]
    #v(-0.3em)
    \ #CHANGE_ME[А. А. Петров]
    #v(-0.3em)
    \ #CHANGE_ME[А. А. Сидоров]
  ]
)

#v(1fr)

#align(center)[
  Минск #CHANGE_ME[2026]
]

#page(footer:none, [
#v(39em)


#block(
  width: 19em,
  [
  \ Решением рабочей комиссии
  \ допущен(а) к защите дипломного проекта
  #v(0.85em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: -0.1em,
    align: center,

    [#underline(offset: 4pt, [#"                             "]) \ #text(size: 8pt)[Подпись]],
    [(#underline(offset: 4pt, [#"                                    "])) \ #text(size: 8pt)[Инициалы и фамилия]]

  )
  #v(-0.3em)
  \ «#underline(offset: 4pt, [#"      "])» #underline(offset: 4pt, [#"                        "]) #CHANGE_ME[2026] г.
  ])
])