// Credit to Dmitry Sebelev (https://github.com/Dmitro44)
// Рамка и основная надпись графического материала

// Перед каждым параметром конфига указан номер графы
// как в пункте 3.1.4 СТП
#let default-config = (
    // Графа 2
    doc-number: "ГУИР.123456.001 СА",
    // Графа 1
    title: (
      "Алгоритм",
    ),
    // Графа 1 (последняя строка)
    doc-type: "Схема алгоритма",
    // Графа правее "Разраб."
    developer: "Иванов",
    // Графа правее "Пров."
    reviewer: "Иванов",
    // Графа правее "Н. контр"
    norm-control: "Сидоров",
    // Графа правее "Реценз."
    approver: "",
    // Графа 4 (ячейка посредине : |   | T |   |)
    lit: "Т",
    // Графа 7
    current-page: "1",
    // Графа 8
    total-pages: "1",
    // Графа 9
    department-group: "Кафедра приколов, гр. 123456",
)

// Рамка графического материала в соответствии с пунктом 3.1.4
//
// Параметры:
//  - type : тип основной надписи как на рисунке 3.1 СТП ("а", "б" или "в")
//  - paper: формат бумаги, например "a1", a2", "a3", "a4".
//  - flipped: альбомная (true) или портретная (false) ориентация;
//  - config: содержимое основной надписи (см. выше);
//  - font : шрифт в основной надписи (визуально в СТП используется Arial,
//           хотя по ГОСТу может потребоваться "GOST Type B")
//  - stroke: толщина рамки страницы (1pt, или 0pt, если рамка не нужна, напр. для плаката)
//  - content: содержимое рамки
#let frame(type:"a", paper:"a4",flipped:false, config: default-config, stroke:1pt, font:"Arial", content) = {

  set page(
    // п. 3.1.3 : расстояние от границы формата 20мм слева 
    //            и 5 мм сверху, справа, снизу
    margin: (left: 20mm, right: 5mm, top: 5mm, bottom: 5mm),
    paper: paper,
    flipped: flipped,
  )

  set text(
    9pt,
    font: font,
    style: "italic",
    hyphenate: false,
  )

  import table: cell

  // Ячейка с ообзначением роли (Разраб., Пров.)
  let role-cell(body) = cell(align: left)[#pad(left: 1pt)[#body]]

  let main-caption(config) = if type == "а" or type == "a"{ 
    // Основная надпись типа 'a'
    table(
    columns: (7mm, 10mm, 23mm, 15mm, 10mm, 70mm, 5mm, 5mm, 5mm, 5mm, 12mm, 18mm),
    rows: (5mm,) * 11,
    align: center + horizon,
    stroke: 1pt,

    [], [], [], [], [],

    cell(colspan: 7, rowspan: 3,  [#config.doc-number]),

    [], [], [], [], [],

    [], [], [], [], [],

    [], [], [], [], [],

    cell(rowspan: 5, [#config.title.join(linebreak()) \ #config.doc-type]),

    cell(colspan: 3)[Лит.], cell(colspan:2)[Масса], [Маштаб],

    [Изм.], [Л.], [№ докум.], [Подп.], [Дата], cell(rowspan:3)[],  cell(rowspan:3)[#config.lit], cell(rowspan:3)[], cell(rowspan:3, colspan:2)[], cell(rowspan:3)[],

    cell(colspan: 2, role-cell[Разраб.]), role-cell[#config.developer], [], [],  

    cell(colspan: 2, role-cell[Пров.]), role-cell[#config.reviewer], [], [],  

    cell(colspan: 2, role-cell[Т. контр]), [], [], [], cell(colspan:4)[ Лист #config.current-page], cell(colspan:2)[Листов #config.total-pages],

    cell(colspan: 2, role-cell[Рецен.]), [],[],[], cell(rowspan:3)[], cell(colspan: 6, rowspan: 3,  [#config.department-group]),

    cell(colspan: 2, role-cell[Н.контр.]), role-cell[#config.norm-control], [], [],

    cell(colspan: 2, role-cell[Утв]), role-cell[#config.approver], [], [],
    )

  } else if type == "б" or type == "b" {
    // Основная надпись типа 'б'
    table(
    columns: (7mm, 10mm, 23mm, 15mm, 10mm, 70mm, 5mm, 5mm, 5mm, 17mm, 18mm),
    rows: (5mm,) * 8,
    align: center + horizon,
    stroke: 1pt,

    [], [], [], [], [], cell(colspan: 6, rowspan: 3, [#config.doc-number]),

    [], [], [], [], [],

    [Изм.], [Л.], [№ докум.], [Подп.], [Дата],

    cell(colspan: 2, role-cell[Разраб.]), role-cell[#config.developer], [], [], cell(rowspan: 5, [#config.title.join(linebreak()) \ #config.doc-type]), cell(colspan: 3)[Лит.], [Лист], [Листов],

    cell(colspan: 2, role-cell[Пров.]), role-cell[#config.reviewer], [], [], [], [#config.lit], [], [#config.current-page], [#config.total-pages],

    cell(colspan: 2)[], [], [], [], cell(colspan: 5, rowspan: 3, [#config.department-group]),

    cell(colspan: 2, role-cell[Н.контр.]), role-cell[#config.norm-control], [], [],

    cell(colspan: 2, role-cell[Утв.]), role-cell[#config.approver], [], [],
    )

  } else if type == "в" or type == "c" {
    // Основная надпись типа 'в'
    table(
    columns: (7mm, 10mm, 23mm, 15mm, 10mm, 110mm, 10mm),
    rows: (5mm, 2mm, 3mm, 5mm),
    align: center + horizon,
    stroke: 1pt,

    [],[],[],[],[], cell(rowspan:4)[#config.doc-number], cell(rowspan:2)[Лист],
    [],[],[],[],[],
    table.hline(stroke: none, start: 0, end:5),

    [],[],[],[],[], cell(rowspan:2)[#config.current-page],
    [Изм.], [Л.], [№ докум.], [Подп.], [Дата],

    )

  } else {
    panic("Unknown frame type " + type + ". Expected  'a', 'б' or 'в'")
  }

  let main-caption-height = if type == "а" or type == "a" {11*5mm}
                       else if type == "б" or type == "b" {8*5mm}
                       else if type == "в" or type == "c" {3*5mm};

  rect(stroke:stroke, inset:0%, grid(
    columns: (1fr,),
    rows: (1fr, main-caption-height),
    [#content],
    align(right,main-caption(config))
  ))

}

#frame([])
