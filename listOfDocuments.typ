#set page(
  paper: "a4",
  margin: (left: 10mm, right: 5mm, top: 5mm, bottom: 10mm)
)

#set text(
  13pt,
  font: "GOST type B",
)

//fake italic
#show text: body => skew(ax: -15deg, body)

#let leftcell(body) = table.cell(align: left)[#pad(left: 5pt)[#body]]

#let empty(prefix: 0) = {
  let empties = ([],) * prefix
  (..empties, [], [], [], [])
}

#let section(title, prefix: 0) = {
  let empties = ([],) * prefix
  (..empties, [], [], table.cell(align: center + horizon, underline[#title]), [])
}

#let d(code, name-lines, note, prefix: 0) = {
  for (i, line) in name-lines.enumerate() {
    let code-cell = if i == 0 { leftcell[#code] } else { [] }

    let note-cell = if i == 0 { note } else { [] }

    (..([ ],) * prefix,
    [],
    code-cell,
    leftcell[#line],
    note-cell)
  }
}

#box(height: 100%)[
  #table(
    align: horizon + center,
    columns: (15pt, 18pt, 20pt, 1fr, 1.1fr, 0.6fr),
    rows: (1fr,) * 38,
    stroke: (x, y) => {
      if x in (2, 3, 4) {
        (left: 2pt, right: 1pt, top: 1pt, bottom: 1pt)
      } else if x == 5{
        (left: 2pt, right: 2pt, top: 1pt, bottom: 1pt)
      } else {
        1pt
      }
    },

    table.cell(rowspan: 7, stroke: 2pt, text(size: 11pt)[#rotate(-90deg, reflow: true)[Перв. примен.]]),
    table.cell(rowspan: 7, stroke: 2pt, text(size: 11pt)[#rotate(-90deg, reflow: true)[ГУИР.ГУИР.353503.023 ПЗ]]),
    table.cell(rowspan: 2, stroke: 2pt, text(size: 12pt)[#rotate(-90deg, reflow: true)[Зона]]),
    table.cell(rowspan: 2, stroke: 2pt, text(size: 14pt)[Обозначение]),
    table.cell(rowspan: 2, stroke: 2pt, text(size: 14pt)[Наименование]),
    table.cell(rowspan: 2, stroke: 2pt, text(size: 14pt)[Дополнительные сведения]),

    ..empty(),

    ..section[Текстовые документы],

    ..empty(),

    ..d(
      "ГУИР КП 6-05-0612-02 023 ПЗ",
      ("Пояснительная записка",),
      "50 c."
    ),

    ..empty(),

// 6 columns

    ..section(prefix: 2)[Графические документы],

    ..empty(prefix: 2),

    ..d("ГУИР.05061202.023.01",
      ("Функциональная схема",
      "алгоритма, реализующего",
      "программное средство"),
      "Формат А3",  prefix: 2
    ),

    ..empty(prefix: 2),

    ..d(
      "ГУИР.05061202.023.02",
      ("Блок схема алгоритма,",
       "реализующего программное",
       "средство"),
      "Формат А3", prefix: 2
    ),

    ..empty(prefix: 2),

    ..d(
      "ГУИР.05061202.023.01 ПЛ",
      ("Графики сравнения",
       "производительности процессоров"),
      "Формат А3", prefix: 2
    ),

    ..empty(prefix: 2),

    ..d(
      "ГУИР.05061202.023.02 ПЛ",
      ("Графическое представление",
       "нагрузки на ядра процессоров"),
      "Формат А3", prefix: 2
    ),

    ..empty(prefix: 2)
 )
]
