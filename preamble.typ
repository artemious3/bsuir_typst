
#let STP2024_template(doc) = {

  // ########################################
  // ##########  GLOBAL STUFF  ##############
  // ########################################

  set page(
    // п. 2.1.1 : формат A4
    paper: "a4",

    // п. 2.1.1 : поля
    margin : (left : 30mm, right : 15mm, top : 20mm, bottom : 20mm),

    footer : context {
      set align(right)
      set text(14pt)
      counter(page).display("1")
    },
    footer-descent : 10mm,
  )

  set text(
    // язык
    lang : "ru",

    // п. 2.1.1 : Шрифт.
    font: "Times New Roman",
    fallback : false,
    style : "normal",
    size : 14pt,

    // строгое соблюдение полей справа
    overhang : false,

    // п. 2.1.1 : Для установки межстрочного интервала.
    // MS Word определяет межстрочный интервал как расстояние 
    // между baselines. Typst -- как расстояние между 
    // bottom-edge первой линии и top-edge следующей.
    // Этот параметр установлен так, чтобы соответствовать
    // поведению Word
    top-edge : "baseline",

    hyphenate : true,
  )

  set par(
    // п. 2.1.1 : Отступ.
    first-line-indent: (amount : 12.5mm, all : true),


    // п. 2.1.1 : Межстрочный интервал 1.0.
    // Пояснение: экспериментально установлено и подтверждено
    // информацией из https://en.wikipedia.org/wiki/Leading,
    // что MS Word определяет одинарный интервал, как 1.15em
    leading : 1.15em,
    
    // п. 2.1.1 : выравнивание по ширине
    justify : true,
  )

  // set block(
  //   stroke : black,
  // )

  // ########################################
  // ##########  HEADINGS      ##############
  // ########################################

  set heading(numbering : "1.1.1.1")

  show heading.where(level:1): body => {
    set text(
      size: 14pt,
      hyphenate : false,
    )

    let number_width = measure(counter(heading).display()).width + 0.1em;

    block(
      spacing:2em,
      grid(
        columns:(12.5mm + number_width, 1fr),
        rows:(auto),
          h(12.5mm) + counter(heading).display(body.numbering),
        upper(body.body)
      )
    )
  }

  show heading.where(level:1): it => {
    pagebreak(weak:true)
    it
  }

  show heading.where(level:2): body => {
    set text(
      size: 14pt,
      hyphenate : false,
    )

    let number_width = measure(counter(heading).display()).width + 0.1em;

    block(
      spacing:2em,
      grid(
        columns:(12.5mm + number_width, 1fr),
        rows:(auto),
          h(12.5mm) + counter(heading).display(body.numbering),
        body.body
      )
    )
}

  show heading.where(level:3): body => {
    set text(
      size: 14pt,
    )
    v(2.3em, weak : true) + box(
     text(
        weight : "bold",
        counter(heading).display(body.numbering)
      )  + " " +  text(
        weight : "regular",
        body.body
      ))
  }

  show heading.where(level:4): body => {
    set text(
      size: 14pt,
    )
    box(
       text(
          weight : "regular",
          counter(heading).display(body.numbering)
        )  + " " 
      )
  }



  // ########################################
  // ##########  LISTS AND ENUMS ############
  // ########################################

  set enum(
    numbering : "1",
    indent : 12.5mm
  )

  show enum: a => {
    let items = a.children.enumerate().map(
      ((index,item)) => par(
        numbering(a.numbering, index+1) + h(0.5em) + item.body)
    )
    items.join()
  }

  set list(
    indent : 12.5mm,
    marker : "–"
  )

  show list: a => {
    let items = a.children.map(
      (item) => par(text(a.marker + h(0.5em) + item.body))
    )
    
    items.join()
  }


  // ########################################
  // ##########  FIGURES AND TABLES #########
  // ########################################
  //

  show heading.where(level:1): it => {
    counter(figure.where(kind:image)).update(0)
    counter(figure.where(kind:table)).update(0)
    it
  }

  set figure.caption(separator: " – ")

  show figure.where(kind: image): set figure(supplement : "Рисунок")
  set figure(numbering : (n) => {
    let heading_counter = str(counter(heading).get().at(0))
     heading_counter + "."  + str(n)
  })

  show figure.where(kind: image): fig => {
    block(
      above : 1.55em,
      below : 2.3em,
      fig.body) + block(
      above : 2.3em,
      below : 2.3em,
      fig.caption)
  }

  show figure.where(kind: table): fig => {
    set block(breakable : true)
    block(
      above : 2.3em,
      below : 0.5em,
      fig.caption) + block(
      above : 0.5em,
      below : 2.3em,
      fig.body)
  }

  show figure.where(kind: table): set figure(supplement : "Таблица")
  show figure.where(kind: table): set align(left)

  // Поскольку Typst считает теперь top-edge текста 
  // его baseline, то верхняя границы клетки таблицы 
  // расположена очень близко к тексту. Нужно добавить 
  // вертикальный отступ
  show table.cell : it => {
    v(0.7em) + it
  }


  show heading.where(level:1): it => {
    counter(math.equation).update(0)
    it
  }
  set math.equation(block: true, numbering: (.., num) => {
   "(" +  str(counter(heading).get().at(0)) + "." + str(num) + ")"
  })
  
  show math.equation : set block(above : 1.55em, below : 2.3em)
  show math.equation : set text(font: "STIX Two Math", weight : "thin")





  // FOOTNOTE

  show footnote.entry : it => {
    set text(
      size : 14pt,
    )
    set par(
      leading : 1.15em,
    )
    it
  }
  set footnote(numbering:"1)")
  set footnote.entry(indent : 12.5mm,
                     separator : line(length: 30% + 0pt, stroke: 1pt),
                      clearance : 0em,
                      gap : 1.15em)


  // REFERENCES

  // убрать из ссылок слова "Таблица", "Рисунок"
  set ref(supplement: none)

  show outline: it => {
    show heading: body => {
      set text(size:14pt)
      set align(center)
      block(upper(body.body), spacing : 2em)
    }
    it
  }

  set outline(depth: 2)

  doc
}

#let abclist(..a) = {
  // п 2.3.8 : Строчные буквы русского алфавита.
  // Предполагаем, что по аналогии с пунктом 2.7.2 
  // о приложениях
  let ru_alph="абвгдежзиклмнпрстуфхцшщэюя".clusters()
  let items = a.pos().enumerate().map(
    ((idx,item)) => par(ru_alph.at(idx) + ")" + h(0.5em) + item)
  )
  items.join()
}

#let explanation(..args) = context {

  let gde_width = measure([где]).width;

  grid(
    columns : (gde_width + 0.5em, 1fr),
    [где],

    grid(
      columns : (auto, 1fr),
      rows : auto,
      column-gutter : 0.5em,
      row-gutter:1.15em,
      ..args
    )
  )
}

#let table-multi-page(continue-header-label: [], continue-footer-label: [], ..table-args) = context {
  let columns = table-args.named().at("columns", default: 1)
  let column-amount = if type(columns) == int {
    columns
  } else if type(columns) == array {
    columns.len()
  } else {
    1
  }

  // Check as show rule for appearance of a header or a footer in grid if value is specified
  let label-has-content = value => value.has("children") and value.children.len() > 0 or value.has("text")

  // Counter of tables so we can create a unique table-part-counter for each table
  let table-counter = counter("table")
  table-counter.step()

  // Counter for the amount of pages in the table
  let table-part-counter = counter("table-part" + str(table-counter.get().first()))

  show <table-footer>: footer => {
    table-part-counter.step()
    context if table-part-counter.get() != table-part-counter.final() and label-has-content(continue-footer-label) {
      footer
    }
  }

  show <table-header>: header => {
    table-part-counter.step()
    set par(first-line-indent: 0em);
    context if (table-part-counter.get().first() != 1) and label-has-content(continue-header-label) {
      header
      v(0.5em)
    }
  }

  grid(
    inset: 0mm,
    grid.header(grid.cell(align(left + bottom)[ #continue-header-label <table-header> ])),
    ..table-args,
    grid.footer(grid.cell(align(right + top)[#continue-footer-label <table-footer> ]))
  )
}

#let longtable(..table-args) = context {
  table-multi-page(
    continue-header-label: [
      Продолжение таблицы #counter(figure.where(kind:table)).display()

    ],
    table(..table-args)
  )
}



