#import table: cell

#set page(
  paper: "a4",
  margin: (left: 10mm, right: 5mm, top: 5mm, bottom: 9mm)
)

#set text(
  13pt,
  font: "GOST type B",
  style: "italic",
  hyphenate: false,
)

#let left-cell(body) = cell(align: left)[#pad(left: 5pt)[#body]]
#let left-footer-cell(body) = cell(align: left)[#pad(left: 1pt)[#body]]

#let right-label(content) = align(
  right,
  pad(right: 10pt, top: 3pt, text(size: 12pt, content))
)

#let empty() = {
  ([], [], [], [])
}

#let section(title) = {
  ([], [], cell(align: center + horizon, underline(offset: 1.5pt)[#title]), [])
}

#let doc(code, name-lines, note) = {
  for (i, line) in name-lines.enumerate() {
    let code-cell = if i == 0 { left-cell[#code] } else { [] }

    let note-cell = if i == 0 { note } else { [] }

    ([],
    code-cell,
    left-cell[#line],
    note-cell)
  }
}

#let count-rows(..cells) = {
  let total-cells = cells.pos().len()
  int(total-cells / 4)
}

#let leftTable(config) = table(
  columns: (14pt, 19pt),
  rows: (153pt, 153pt, 108pt, 88pt, 65pt, 66pt, 86pt, 1fr),
  align: center + horizon,
  stroke: 2pt,
  text(size: 10pt, rotate(-90deg, reflow: true)[Перв. примен.]),
  text(size: 11pt, rotate(-90deg, reflow: true)[#config.left-doc-number]),

  text(size: 10pt, rotate(-90deg, reflow: true)[Справочный №]),
  text(size: 10pt, rotate(-90deg, reflow: true)[]),

  cell(stroke: none, []),
  cell(stroke: none, []),

  text(size: 10pt, rotate(-90deg, reflow: true)[Подпись и дата]),
  text(size: 10pt, rotate(-90deg, reflow: true)[]),

  text(size: 10pt, rotate(-90deg, reflow: true)[Инв. № дубл.]),
  text(size: 10pt, rotate(-90deg, reflow: true)[]),

  text(size: 10pt, rotate(-90deg, reflow: true)[Взам. Инв. №]),
  text(size: 10pt, rotate(-90deg, reflow: true)[]),

  text(size: 10pt, rotate(-90deg, reflow: true)[Подпись и дата]),
  text(size: 10pt, rotate(-90deg, reflow: true)[]),

  text(size: 10pt, rotate(-90deg, reflow: true)[Инв. № подл.]),
  text(size: 10pt, rotate(-90deg, reflow: true)[]),
)

#let mainTable(config) = {
  let total-rows = 30

  let content = (
    cell(rowspan: 2, stroke: 2pt, text(size: 12pt, rotate(-90deg)[Зона])),
    cell(rowspan: 2, stroke: 2pt, text(size: 15pt)[Обозначение]),
    cell(rowspan: 2, stroke: 2pt, text(size: 15pt)[Наименование]),
    cell(rowspan: 2, stroke: 2pt, text(size: 14pt)[Дополнительные сведения]),

    ..empty(),
  )

  for item in config.documents {
    if "section-title" in item {
      content += section[#item.section-title]
      content += empty()
    } else {
      content += doc(item.code, item.name-lines, item.note)
      content += empty()
    }
  }

  let used-rows = count-rows(..content)
  let remaining-rows = total-rows - used-rows

  table(
    columns: (22pt, 1fr, 1.1fr, 0.6fr),
    rows: (1fr,) * total-rows,
    align: center + horizon,
    stroke: (x, y) => {
      if x in (0, 1, 2) {
        (left: 2pt, right: 1pt, top: 1pt, bottom: 1pt)
      } else if x == 3{
        (left: 2pt, right: 2pt, top: 1pt, bottom: 1pt)
      } else {
        1pt
      }
    },

    ..content,
    ..empty() * remaining-rows
  )
}

#let footerTable(config) = {
  text(size: 10pt, table(
  columns: (0.65fr, 0.8fr, 2fr, 1.3fr, 0.8fr, 6fr, 0.43fr, 0.43fr, 0.43fr, 1.3fr, 1.3fr),
  rows: (1fr,) * 8,
  align: center + horizon,
  stroke: (x, y) => {
    if x in range(5) {
      let top-width = if y in (1, 4, 5, 6, 7) { 1pt } else { 2pt }
      (left: 2pt, right: 2pt, top: top-width, bottom: 2pt)
    } else {
      2pt
    }
  },

  [],
  [],
  [],
  [],
  [],
  cell(colspan: 6, rowspan: 3, text(size: 20pt, [#config.doc-number])),
  //row

  [], [], [], [], [],
  //row

  [Изм.], [Лист], [№ докум.], [Подп.], [Дата],
  //row

  cell(colspan: 2, left-footer-cell[Разраб.]), left-footer-cell[#config.developer], [], [], cell(rowspan: 5, text(size: 10pt, [#config.title.join(linebreak()) \ #text(size:12pt)[#config.doc-type]])), cell(colspan: 3)[Лит.], [Лист], [Листов],
  //row

  cell(colspan: 2, left-footer-cell[Пров.]), left-footer-cell[#config.reviewer], [], [], [], [#config.lit], [], [#config.current-page], [#config.total-pages],
  //row

  cell(colspan: 2)[], [], [], [], cell(colspan: 5, rowspan: 3, text(size: 12pt, [#config.department \ группа #config.group])),
  //row

  cell(colspan: 2, left-footer-cell[Н.контр.]), left-footer-cell[#config.norm-control], [], [],
  //row

  cell(colspan: 2, left-footer-cell[Утв.]), left-footer-cell[#config.approver], [], [],
  ))
}

#let main-table-config = (
  documents: (
    (section-title: "Текстовые документы"),

    (
      code: "ГУИР КП 6-05-0612-02 023 ПЗ",
      name-lines: ("Пояснительная записка",),
      note: "50 c."
    ),

    (section-title: "Графические документы"),

    (
      code: "ГУИР.05061202.023.01",
      name-lines: (
        "Функциональная схема",
        "алгоритма, реализующего",
        "программное средство"
      ),
      note: "Формат А3"
    ),

    (
      code: "ГУИР.05061202.023.02",
      name-lines: (
        "Блок схема алгоритма,",
        "реализующего программное",
        "средство"
      ),
      note: "Формат А3"
    ),
    (
      code: "ГУИР.05061202.023.01 ПЛ",
      name-lines: (
        "Графики сравнения",
        "производительности процессоров"
      ),
      note: "Формат А3"
    ),
    (
      code: "ГУИР.05061202.023.02 ПЛ",
      name-lines: (
        "Графическое представление",
        "нагрузки на ядра процессоров"
      ),
      note: "Формат А3"
    ),
  )
)

#let left-table-config = (
  left-doc-number: "ГУИР.ГУИР.353503.023 ПЗ",
)

#let footer-table-config = (
  doc-number: "ГУИР КП 6-05-0612-02 023 ПЗ",
  title: (
    "СРАВНЕНИЕ ПРОИЗВОДИТЕЛЬНОСТИ",
    "ПРОЦЕССОРОВ INTEL CORE I5-12450H И",
    "AMD RYZEN 7 5800H НА ОСНОВЕ",
    "ВЫПОЛНЕНИЯ ПРЕОБРАЗОВАНИЙ ФУРЬЕ"
  ),
  doc-type: "Ведомость курсового проекта",
  developer: "Себелев",
  reviewer: "Калиновская",
  norm-control: "Калиновская",
  approver: "Марков",
  lit: "Т",
  current-page: "50",
  total-pages: "50",
  department: "Кафедра информатики",
  group: "353503"
)

#let create_form = grid(
  columns: (auto, auto),
  rows: (1fr, auto),

  grid.cell(rowspan: 1, leftTable(left-table-config)),
  grid(
    columns: (1fr,),
    rows: (1fr, 0.17fr),
    mainTable(main-table-config),
    footerTable(footer-table-config)
  ),
  grid.cell(colspan: 2)[#right-label[Формат А4]]
)

#create_form
