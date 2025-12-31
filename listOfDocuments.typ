#import table: cell

#set page(
  paper: "a4",
  margin: (left: 10mm, right: 5mm, top: 5mm, bottom: 10mm)
)

#set text(
  13pt,
  font: "GOST type B",
  style: "italic",
  hyphenate: false,
)

#let leftcell(body) = table.cell(align: left)[#pad(left: 5pt)[#body]]

#let empty() = {
  ([], [], [], [])
}

#let section(title) = {
  ([], [], table.cell(align: center + horizon, underline[#title]), [])
}

#let d(code, name-lines, note) = {
  for (i, line) in name-lines.enumerate() {
    let code-cell = if i == 0 { leftcell[#code] } else { [] }

    let note-cell = if i == 0 { note } else { [] }

    ([],
    code-cell,
    leftcell[#line],
    note-cell)
  }
}

#box(height: 100%)[
  #set rotate(reflow: true)
  #table(
    align: horizon + center,
    columns: (15pt, 18pt, 20pt, 1fr, 1.1fr, 0.6fr),
    rows: (1fr,) * 36,
    stroke: (x, y) => {
      if x in (2, 3, 4) {
        (left: 2pt, right: 1pt, top: 1pt, bottom: 1pt)
      } else if x == 5{
        (left: 2pt, right: 2pt, top: 1pt, bottom: 1pt)
      } else {
        1pt
      }
    },

    cell(rowspan: 7, stroke: 2pt, text(size: 10pt, rotate(-90deg)[Перв. примен.])),
    cell(rowspan: 7, stroke: 2pt, text(size: 11pt, rotate(-90deg)[ГУИР.ГУИР.353503.023 ПЗ])),
    cell(rowspan: 2, stroke: 2pt, text(size: 12pt, rotate(-90deg)[Зона])),
    cell(rowspan: 2, stroke: 2pt, text(size: 14pt)[Обозначение]),
    cell(rowspan: 2, stroke: 2pt, text(size: 14pt)[Наименование]),
    cell(rowspan: 2, stroke: 2pt, text(size: 14pt)[Дополнительные сведения]),

    ..empty(),

    ..section[Текстовые документы],

    ..empty(),

    ..d(
      "ГУИР КП 6-05-0612-02 023 ПЗ",
      ("Пояснительная записка",),
      "50 c."
    ),

    ..empty(),

    cell(rowspan: 7, stroke: 2pt, text(size: 10pt, rotate(-90deg)[Справочный №])),
    cell(rowspan: 7, stroke: 2pt)[],

    ..section()[Графические документы],

    ..empty(),

    ..d("ГУИР.05061202.023.01",
      ("Функциональная схема",
      "алгоритма, реализующего",
      "программное средство"),
      "Формат А3"
    ),

    ..empty(),


    ..d(
      "ГУИР.05061202.023.02",
      ("Блок схема алгоритма,",),
      "Формат А3"
    ),

    cell(rowspan: 5, stroke: none, []),
    cell(rowspan: 5, stroke: none, []),

    ..d(
      "",
      ("реализующего программное",
       "средство"),
      ""
    ),


    ..empty(),

    ..d(
      "ГУИР.05061202.023.01 ПЛ",
      ("Графики сравнения",
       "производительности процессоров"),
      "Формат А3"
    ),

    cell(rowspan: 4, stroke: 2pt, text(size: 10pt, rotate(-90deg)[Подпись и дата])),
    cell(rowspan: 4, stroke: 2pt,[]),

    ..empty(),

    ..d(
      "ГУИР.05061202.023.02 ПЛ",
      ("Графическое представление",
       "нагрузки на ядра процессоров"),
      "Формат А3"
    ),

    ..empty(),

    cell(rowspan: 3, stroke: 2pt, text(size: 10pt, rotate(-90deg)[Инв. № дубл.])),
    cell(rowspan: 3, stroke: 2pt, []),

    ..empty() * 3,

    cell(rowspan: 3, stroke: 2pt, text(size: 10pt, rotate(-90deg)[Взам. Инв. №])),
    cell(rowspan: 3, stroke: 2pt, []),

    ..empty() * 3,

    cell(rowspan: 4, stroke: 2pt, text(size: 10pt, rotate(-90deg)[Подпись и дата])),
    cell(rowspan: 4, stroke: 2pt, []),

    ..empty() * 4,

    cell(rowspan: 3, stroke: 2pt, text(size: 10pt, rotate(-90deg)[Инв. № подл.])),
    cell(rowspan: 3, stroke: 2pt, []),
 )
]
