

#let STP2024(doc) = {

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
      if counter(page).get().at(0) != 1 {
        counter(page).display("1")
      } else {
        []
      }
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
  //
  //



  // ########################################
  // ##########  HEADINGS      ##############
  // ########################################

  set heading(numbering : "1.1.1.1")

  show heading.where(level:1): body => {
    set text(
      size: 14pt,
      hyphenate : false,
    )

    set par(
      justify : false
    )

    let number_width = measure(counter(heading).display()).width + 0.1em;

    let counter_str = if body.numbering != none {
      counter(heading).display(body.numbering)
    } else {
      ""
    }

    block(
      spacing:2.3em,
      grid(
        columns:(12.5mm + number_width, 1fr),
        rows:(auto),
          h(12.5mm) + counter_str,
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

    set par(
      justify : false
    )

    let number_width = measure(counter(heading).display()).width + 0.1em;

    let counter_str = if body.numbering != none {
      counter(heading).display(body.numbering)
    } else {
      ""
    }

    block(
      spacing:2.3em,
      grid(
        columns:(12.5mm + number_width, 1fr),
        rows:(auto),
          h(12.5mm) + counter_str,
        body.body
      )
    )
}

  show heading.where(level:3): body => {
    set text(
      size: 14pt,
      hyphenate: false
    )

    let counter_str = if body.numbering != none {
      counter(heading).display(body.numbering)
    } else {
      ""
    }
    v(2.3em, weak : true) + box(
     text(
        weight : "bold",
        counter_str
      )  + " " +  text(
        weight : "regular",
        body.body
      ))
  }

  show heading.where(level:4): body => {
    set text(
      size: 14pt,
    )

    let counter_str = if body.numbering != none {
      counter(heading).display(body.numbering)
    } else {
      ""
    }

    box(
       text(
          weight : "regular",
          counter_str
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
      ((index,item)) =>
        numbering(a.numbering, index+1) + h(0.5em) + item.body + parbreak()
    )
    parbreak()+items.join()
  }

  set list(
    indent : 12.5mm,
    marker : "–"
  )

  show list: a => {
    let items = a.children.map(
      (item) =>
        a.marker + h(0.5em) + item.body + parbreak()
    )

   parbreak()+items.join()
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
    set text(hyphenate:false)
    block(
      above : 1.55em,
      below : 2.3em,
      fig.body) + block(
      above : 2.3em,
      below : 2.3em,
      fig.caption)
  }

  show figure.where(kind: table): fig => {
    set text(hyphenate:false)
    set block(breakable : true)
    block(
      above : 2.3em,
      below : 0.5em,
      fig.caption) + block(
      above : 0.5em,
      below : 2.3em,
      fig.body)
  }

  show figure.where(kind:table): it => context {
      set figure(supplement : "Таблица")
      set align(left)

      show figure.caption: b => context {
        set text(hyphenate: false)
        let counter = counter(figure.where(kind:table)).display()
        let counter_width = measure(counter).width
        let supplement_width = measure(b.supplement + b.separator).width
        grid(
          columns:(supplement_width + counter_width, 1fr),
          b.supplement + " " + counter + b.separator, b.body
        )
      }

      it
  }

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
  show math.equation : set text(font: "TeX Gyre Termes Math", style : "italic")





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


  // убрать из ссылок слова "Таблица", "Рисунок"
  set ref(supplement: none)

  show outline: it => {
    show heading: body => {
      set text(size:14pt, hyphenate:false)
      set align(center)
      block(upper(body.body), spacing : 2.3em)
    }
    set text(
      hyphenate: false
    )
    it
  }

  set outline(depth: 2)

  set bibliography(
    title : [Список литературных источников],
    style : "gost-r-7-0-5-2008-VAK9.csl",
    full:true,
  )

  show bibliography: it => {
    show heading : h => {
      set text(size:14pt, hyphenate:false)
      set align(center)

      pagebreak(weak:true)
      block(upper(it.at("title")), below : 2.3em)
      v(1.15em)
    }

    // hacky but works
    show block:  it => {
      par(it.body)
    }

    set par(
      first-line-indent: (amount : 12.5mm, all:true),
    )
    it
  }


  doc
}


// п 2.7.2 : пропускаем некоторые буквы русского алфавита
// для приложений и (вероятно, по аналогии) списков
#let ru_alph="абвгдежзиклмнпрстуфхцшщэюя".clusters()

#let abclist(..a) = {
  // п 2.3.8 : Строчные буквы русского алфавита.
  // Предполагаем, что по аналогии с пунктом 2.7.2
  // о приложениях
  let items = a.pos().enumerate().map(
    ((idx,item)) => ru_alph.at(idx) + ")" + h(0.5em) + item + parbreak()
  )
  parbreak()+items.join()
}

#let explanation(..args) = context {

  let gde_width = measure([где]).width;

  grid(
    columns : (gde_width + 0.5em, 1fr),
    [где],

    grid(
      columns : (auto, 1fr),
      align : (right, left),
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


#let heading_unnumbered(body) = {
  show heading: it => {
    set align(center)
    set text(size:14pt, weight:"semibold", hyphenate:false)
    block(upper(it.body), spacing : 2.3em)
  }
  heading(body, numbering:none)
}



#let appendix(..args, body) = context {
  counter(figure.where(kind:image)).update(0)
  counter(figure.where(kind:table)).update(0)

  let cnt = counter("appendix")
  let cnt_disp = upper(ru_alph.at(cnt.get().at(0)))
  let atype = args.at("type")
  let aname = args.at("title")


  show heading: it =>  {
    set text(size:14pt, hyphenate:false)
    set align(center)
    pagebreak(weak:true)
    block([ПРИЛОЖЕНИЕ #cnt_disp \ (#atype) \ #aname], below:2.3em)
  }

  set figure(numbering : (n) => {
    let heading_counter = upper(ru_alph.at(counter("appendix").get().at(0)))
     heading_counter + "."  + str(n)
  })

  heading(outlined:false,[])

  {
      show figure: none;
      [#figure(
              kind:"hidden_appendix",
              supplement : [Приложение],
              numbering: (..)=>cnt_disp,
              caption: [(#atype) #aname])[]<appendix>]
  }
  body

  counter("appendix").step()
}
