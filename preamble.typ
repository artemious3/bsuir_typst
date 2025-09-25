
#let STP2024_template(doc) = {

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
    // между baselines, в отличии от Typst. Этот параметр 
    // исправляет это.
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
    // leading : 1.15em,
    leading : 1.15em,
    
    // п. 2.1.1 : выравнивание по ширине
    justify : true,
  )

  set block(
    spacing : 1.3em
  )

  set heading(numbering : "1.1.1")

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
          h(12.5mm) + counter(heading).display(),
        upper(body.body)
      )
    )
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
          h(12.5mm) + counter(heading).display(),
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
        counter(heading).display()
      )  + " " +  text(
        weight : "regular",
        body.body
      ))
  }

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

  show figure.where(kind: image): set figure(supplement : "Рисунок")

  show figure.where(kind: image): fig => {
    block(
      above : 1.5em,
      below : 2.3em,
      fig.body) + block(
      above : 2.3em,
      below : 2.3em,
      fig.caption)
  }

  show figure.where(kind: table): set figure(supplement : "Таблица")

  set math.equation(block: true, numbering: "(1)")

  doc
}
