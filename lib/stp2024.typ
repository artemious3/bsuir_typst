// -------------------------------------------
// Набор функций для оформления по СТП 01-2024
// -------------------------------------------

// Typst сам по себе не имеет figure kind code, поэтому определим его здесь
#let code_kind = "code"


// -----------------------------------------------
// Шаблон для документа, оформленного по СТП 2024.
// Стандартное использование: 
//
// ```
// #show: stp2024.template
// ```
//
// Всё содержание документа, следующее за этим выражением,
// будет обёрнуто в функцию template
// -----------------------------------------------
#let template(first_page_number : false, doc) = {


  // Оформление текста
  set text(
    // язык пояснительной записки
    lang : "ru",

    // п. 2.1.1 : Шрифт
    font: "Times New Roman",
    fallback : false,
    style : "normal",
    size : 14pt,

    // строгое соблюдение полей справа
    overhang : false,

    // п. 2.1.1 : Для установки межстрочного интервала.
    //            MS Word определяет межстрочный интервал как расстояние
    //            между baselines. Typst -- как расстояние между
    //            bottom-edge первой линии и top-edge следующей.
    //            Этот параметр установлен так, чтобы соответствовать
    //            поведению Word
    top-edge : "baseline",

    // п. 2.1.1 : Переносы в пояснительной записке разрешены везде, кроме 
    //            названий разделов, подразделов, таблиц, рисунков 
    //            (эти запреты установлены далее).
    hyphenate : true,
  )


  // Офомление страницы
  set page(
    // п. 2.1.1 : Формат A4
    paper: "a4",

    // п. 2.1.1 : Поля.
    //            Верхнее поле это расстояние от
    //            верхнего края страницы до базовой линии
    //            первой строки (ибо top-edge равен "baseline").
    //            В таком случае поле не соблюдается, нужно добавить
    //            пробельную строку, высота которой 1.15em
    margin : (left : 30mm, right : 15mm, top : 20mm + 1.15em, bottom : 20mm),

    // п. 2.2.8 : Нумерация страниц арабскими цифрами
    //            в правом нижнем углу, титульный лист 
    //            не нумеруется.
    footer : context {
      set align(right)
      set text(14pt)
      if first_page_number or counter(page).get().at(0) != 1 {
        counter(page).display("1")
      } else {
        []
      }
    },

    // Приложение Л : Расстояние от номера страницы 
    //                до нижнего края листа.
    footer-descent : 10mm,
  )


  // Оформление абзаца
  set par(
    // п. 2.1.1 : Абзацный отступ.
    first-line-indent: (amount : 12.5mm, all : true),


    // п. 2.1.1 : Межстрочный интервал 1.0.
    //            Пояснение: экспериментально установлено и подтверждено
    //            информацией из https://en.wikipedia.org/wiki/Leading,
    //            что MS Word определяет одинарный интервал, как 1.15em
    leading : 1.15em,

    // п. 2.1.1 : Отступ между абзацами такой же, как межстрочный интервал
    //            внутри абзаца.
    spacing : 1.15em,

    // п. 2.1.1 : Выравнивание по ширине
    justify : true,
  )


  // п. 2.2.3 : Допускается деление на разделы, 
  //            подразделы, пункты и подпункты.
  set heading(numbering : "1.1.1.1")

  // Общая процедура для формирования заголовков разделов и подразделов
  let _heading_with_indent(numbering, title) = {
    set text(
      // п 2.2.1 : Размер шрифта
      size: 14pt,
      // п 2.2.1 : Запрет на переносы в названиях разделов
      hyphenate : false,
    )


    // Не растягивать строки в названиях разделов по
    // всей ширине
    set par(
      justify : false
    )

    let number_width = measure(counter(heading).display()).width + 0.1em;

    // п. 2.2.2 : Разделы имеют порядковые номера,
    let counter_str = if numbering != none {
      counter(heading).display(numbering)
    } else {
      ""
    }

    // п. 2.2.2, 2.2.4:
    //
    // Формируем сетку следующего вида:
    //
    //    абз. отступ
    // <------>
    // |      <Номер> | <Название>             |
    // |              | <Продолжение названия> |
    block(
      // п. 2.2.6 : пробельная строка 
      spacing:2.3em,
      grid(
        columns:(12.5mm + number_width, 1fr),
        rows:(auto),
          h(12.5mm) + counter_str,
          title
      )
    )
  }


  // Оформление заголовка первого уровня (раздела)
  show heading.where(level:1): body => {
    // п. 2.2.6 : Разделы рекомендуется начинать с новой страницы
    pagebreak(weak:true)
    // п. 2.2.5 : Заголовки разделов записываются прописными буквами
    _heading_with_indent(body.numbering, upper(body.body))
  }


  // Оформление заголовка первого уровня (подраздела)
  show heading.where(level:2): body => {
    // п. 2.2.5 : Заголовки подразделов записываются строчными буквами
    _heading_with_indent(body.numbering, body.body)
  }


  // Оформление заголовка третьего уровня (пунктов)
  show heading.where(level:3): body => {
    set text(
      size: 14pt,
    )

    let counter_str = if body.numbering != none {
      counter(heading).display(body.numbering)
    } else {
      ""
    }
    // Приложение Л : Оформление пунктов.
    //                Пробельная строка между пунктами.
    v(2.3em, weak : true) + box(
     text(
        weight : "bold",
        counter_str
      )   +
      " " +
      text(
        weight : "regular",
        body.body
      )
    )
  }


  // Оформление заголовков 4-го уровня (подпунктов)
  show heading.where(level:4): body => {
    set text(
      size: 14pt,
    )

    let counter_str = if body.numbering != none {
      counter(heading).display(body.numbering)
    } else {
      ""
    }

    // Приложение Л : оформление подпунктов
    box(
       text(
          weight : "regular",
          counter_str
        )  + " "
      )
  }


  // п. 2.3.7 : Оформление нумерованных перечислений
  set enum(
    numbering : "1",
  )
  show enum: a => {
    let items = a.children.enumerate().map(
      ((index,item)) =>
        numbering(a.numbering, index+1) + h(0.5em) + item.body + parbreak()
    )
    parbreak()+items.join()
  }


  // Оформление ненумерованных перечислений (п. 2.3.5)
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


  // п. 2.6.2,
  // п. 2.5.5 : Поскольку используется нумерация с номером раздела, 
  //            сбрасываем счётчик таблиц и рисунков с каждым 
  //            новым разделом
  show heading.where(level:1): it => {
    counter(figure.where(kind:image)).update(0)
    counter(figure.where(kind:table)).update(0)
    counter(figure.where(kind:code_kind)).update(0)
    it
  }

  // п. 2.6.2,
  // п. 2.5.5 : Номер и название рисунков и таблиц разделяется знаком "тире"
  set figure.caption(separator: " – ")

  // п. 2.5.5 : Нумерация рисунка содержит номер раздела
  set figure(numbering : (n) => {
    let heading_counter = str(counter(heading).get().at(0))
     heading_counter + "."  + str(n)
  })


    // п. 2.5.5 : Слово "Рисунок" в названии рисунка
  show figure.where(kind: image): set figure(supplement:"Рисунок")
  show figure.where(kind: image): fig => {
    // п. 2.1.1 : Запрет переносов в названии рисунков
    set text(hyphenate:false)

    // Приложение Л : Пробельная строка перед рисунком,
    //                перед подписью и после подписи
    block(
      // К расстоянию между базовыми линиями добавляется descender height 
      // (см. https://en.wikipedia.org/wiki/Typeface_anatomy), которую 
      // мы примерно определили как 0.5em.
      above : 1.65em,

      // Одну строку мы пропускаем, поэтому расстояние до следующей базовой линии 
      // равно 2 * 1.15em
      //
      // ^     _____________ - нижняя линия рисунка
      // |     XXXXXXXXXXXXX - пробельная строка
      // |     ^^^^^^^^^^^^^ - базовая линия 
      // |     Lorem ipsum d - строка следующего абзаца
      // *     ^^^^^^^^^^^^^ - базовая линия слеюующего абзаца
      //
      // Итого два межстрочных интервала. 
      below : 2.3em,
      fig.body) + block(
      above : 2.3em,
      below : 2.3em,
      fig.caption)
  }

  // Попытка угадать, как должен форматироваться листинг программного кода
  show figure.where(kind:code_kind): set figure.caption(position: top)
  show figure.where(kind:code_kind): it => context {
    show raw: set text(font: "Courier New", size: 10pt)

    set align(left)

    set block(breakable : true)

    show figure.caption: b => context {
      // п. 2.1.1 : Запрет на переносы в назввании таблицы по логике относится и к листингу
      set text(hyphenate: false)
      let counter = counter(figure.where(kind:code_kind)).display()
      let counter_width = measure(counter).width
      let supplement_width = measure(b.supplement + b.separator).width

      // Приложение Л : 
      // Формируем сетку следующего вида 
      //
      // | Таблица <Номер> -- | <Название              |
      // |                    | <Продолжение названия> |
      grid(
        columns:(supplement_width + counter_width, 1fr),
        b.supplement + " " + counter + b.separator,
        b.body
      )
    }

    block(
      above : 2.3em,
      below : 1em,
      it.caption) + block(
      above : 0em,
      below : 2.3em,
        it.body)
  }


  // Судя по всему, интервал между границей клетки и текстом
  // в Typst откладывается до top-edge текста. Так как top-edge
  // в данном шаблоне есть базовая линия, то она оказывается
  // слишком близко к верхней границе. Исправим это установкой
  // inset (значение установлено экспирементально).
  set table(inset:(top:0.9em))

  // п. 2.6.2 : Слово "Таблица" в названии таблиц
  show figure.where(kind:table): set figure(supplement : "Таблица")
  show figure.where(kind:table): it => context {

    set align(left)

    set block(breakable : true)

    show figure.caption: b => context {
      // п. 2.1.1 : Запрет на переносы в назввании таблицы
      set text(hyphenate: false)
      let counter = counter(figure.where(kind:table)).display()
      let counter_width = measure(counter).width
      let supplement_width = measure(b.supplement + b.separator).width

      // Приложение Л : 
      // Формируем сетку следующего вида 
      //
      // | Таблица <Номер> -- | <Название              |
      // |                    | <Продолжение названия> |
      grid(
        columns:(supplement_width + counter_width, 1fr),
        b.supplement + " " + counter + b.separator,
        b.body
      )
    }

    block(
      above : 2.3em,
      // От базовой линии надписи до верхней грани таблицы 
      // остаётся только расстояние descender height
      below : 0.5em,
      it.caption) + block(
      above : 0.5em,
      below : 2.3em,
        it.body)
  }

  // п. 2.4.6 : Рекомендуется нумеровать формулы в пределах раздела.
  //            Сброс счётчика формул после начала раздела.
  show heading.where(level:1): it => {
    counter(math.equation).update(0)
    it
  }
  // п. 2.4.6 : Оформление номера формулы
  set math.equation(block: true, numbering: (.., num) => {
    // По умолчанию для номера используется тот же шрифт,
    // что и для самой формулы, исправляем это.
    set text(font:"Times New Roman", style:"normal")
   "(" +  str(counter(heading).get().at(0)) + "." + str(num) + ")"
  })

  // п. 2.4.3 : Формулы отделяют пробельной строкой
  show math.equation : set block(above : 1.55em, below : 2.3em)

  // Приложение Ф : Используем шрифт, близкий к используемому в образце.
  show math.equation : set text(font: "TeX Gyre Termes Math", style : "italic")

  // п. 2.9.1,
  // п. 2.9.2 : Оформление сносок
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


  // Для документов на русском языке убираем слова "Рисунок" и 
  // "Таблица" из ссылок, чтобы вручную согласовывать их грамматическую 
  // форму
  set ref(supplement: none)

  // п. 2.2.7 : Оформление содержания
  show outline: it => {
    show heading: body => {
      set text(size:14pt, hyphenate:false, weight:"semibold")
      set align(center)
      block(upper(body.body), spacing : 2.3em)
    }
    set text(
      hyphenate: false
    )
    it
  }

  // п. 2.2.7 : Содержание содержит только разделы и подразделы
  set outline(depth: 2)

  // п. 2.8.1 : Оформление списка использованных источников
  set bibliography(
    title : [Список использованных источников],
    // п. 2.8.5 : Близкий к ГОСТ 7.1-2003 стиль оформления
    style : "gost-r-7-0-5-2008-VAK9.csl",
    full:true,
  )

  show bibliography: it => {
  // п. 2.8.1 : Название "Список использованных источников"
    show heading : h => {
      set text(size:14pt, hyphenate:false)
      set align(center)
      pagebreak(weak:true)
      block(upper(it.at("title")))
      v(1.15em)
    }

    // Чтобы добиться абзацного отступа перед каждым источником
    // вместо block, используемого по-умолчанию, оборачиваем каждый 
    // источник в par.
    show block:  it => {
      // Добавляем пробел фиксированного размера после номера элемента 
      // списка источников. Пока Typst не позволяет серьёзно кастомизировать 
      // bibliography, обходимся таким неаккуратным решением.
      show "] ": "]" + h(0.4em)
      par(it.body, first-line-indent: (amount : 12.5mm, all:true))
    }

    it
  }


  doc
}


// -------------------------------------------------------------------
// Русский алфавит.
// п 2.7.2 : Пропускаем некоторые буквы русского алфавита
//           для приложений и (вероятно, по аналогии) списков
// ----------------------------------------------------------------------
#let ru_alph="абвгдежзиклмнпрстуфхцшщэюя".clusters()


// -------------------------------------------------------------------
// Вариант перечисления, нумеруемый строчными буквами русского алфавита
// В качестве аргументов передаются элементы перечисления, например 
//
// ```
// #stp2024.abclist([элемент 1], [элемент 2], [элемент 3])
// ```
// ----------------------------------------------------------------------
#let abclist(..a) = {
  // п 2.3.8 : Используем строчные буквы русского алфавита, 
  //           отделяемые скобкой; после каждого элемента,
  //           вставляем разрыв абзаца
  let items = a.pos().enumerate().map(
    ((idx,item)) => ru_alph.at(idx) + ")" + h(0.5em) + item + parbreak()
  )
  parbreak()+items.join()
}


// -----------------------------------------------------------------------
// Перечень и расшифровка приведенных в формуле символов (согласно п. 2.4.7).
// В списке аргументов каждый нечетный элемент -- символ, а чётный, следующий 
// за ним, -- расшифровка символа. Пример использования: 
//
// ```
// #stp2024.explanation(
//    [$U$ -- ], [напряжение],
//    [$I$ -- ], [сила тока],
// )
// ```
// ------------------------------------------------------------------------
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


// Функция, позволяющая добавить надпись "Продолжение таблицы X",
// позаимствованная у кого-то на Github
#let _table_multi_page(continue-header-label: [], continue-footer-label: [], ..table-args) = context {
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


// ----------------------------------------------------------
// Таблица, которую можно разместить на нескольких страницах.
// Заголовок таблица повторяется, на каждой странице кроме первой 
// используется надпись "Продолжение таблицы <Номер>".
//
// Используется точно так же, как и стандартная `table`, однако для 
// использования с figure, нужно добавить `kind:table`. Пример: 
//
// ```
// #figure(
//  caption : [Название],
//  kind:table,
//  stp2024.longtable(<...>)
// )
// ```
// ----------------------------------------------------------
#let longtable(..table-args) = context {
  _table_multi_page(
    continue-header-label: [
      Продолжение таблицы #counter(figure.where(kind:table)).display()
    ],
    table(..table-args)
  )
}


// ----------------------------------------------------------
// Ненумеруемый заголовок, например для введения или заключения. 
// Пример: 
// 
// ```
// #stp2024.heading_unnumbered([Заключение])
// ```
// ----------------------------------------------------------
#let heading_unnumbered(body) = {
  show heading: it => {
    set align(center)
    set text(size:14pt, weight:"semibold", hyphenate:false)
    block(upper(it.body), spacing : 2.3em)
  }
  heading(body, numbering:none)
}



// ----------------------------------------------------------
// Приложение (согласно п. 2.7.1, 2.7.2, 2.7.3).
// Обязательные аргументы: 
//  - kind : тип приложения (обязательное, рекомендуемое или справочное )
//  - title : название приложения
// 
// Последним аргументом используется содержание приложения. 
// Пример использования: 
//
// ```
// #stp2024.appendix(
//  title : [Ответ на главный вопрос жизни],
//  type : [обязательное],
//  [ 
//    Ответ на главный вопрос жизни - 42.
//  ]
// )
// ```
// ----------------------------------------------------------
#let appendix(..args, body) = context {
  // Сбрасываем счётчики таблиц, изображений, формул
  counter(figure.where(kind:image)).update(0)
  counter(figure.where(kind:table)).update(0)
  counter(figure.where(kind:code_kind)).update(0)
  counter(math.equation).update(0)

  let cnt = counter("appendix")
  let cnt_disp = upper(ru_alph.at(cnt.get().at(0)))
  let atype = args.at("type")
  let aname = args.at("title")


  // п. 2.7.3 : Название приложения
  show heading: it =>  {
    set text(size:14pt, hyphenate:false)
    set align(center)
    pagebreak(weak:true)
    block([ПРИЛОЖЕНИЕ #cnt_disp \ (#atype) \ #aname], below:2.3em)
  }

  let heading_counter = upper(ru_alph.at(counter("appendix").get().at(0)))

  // п. 2.5.5,
  // п. 2.6.2 : Рисунки и таблицы содержат буквенное обознаячение приложения
  set figure(numbering : (n) => {
     heading_counter + "."  + str(n)
  })

  // п. 2.4.6 : Номер формулы содержит буквенное обозначение приложения
  set math.equation(numbering : (n) => {
    set text(font:"Times New Roman", style:"normal")
   "(" +  heading_counter + "." + str(n) + ")"
  })

  // Не отображаем приложения в содержании напрямую, вместо этого используем 
  // спрятанный figure
  heading(outlined:false,[])

  // Спрятанный figure для правильного оформления списка приложений в содержании
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


// ----------------------------------------------------------
// Полное содержание, включающее приложения.
// Необходимо, поскольку для правильного оформления содержания 
// приложений используется невидимый figure.
// ----------------------------------------------------------
#let full_outline() = {
  outline()
  outline(title:none,target:label("appendix"))
  pagebreak(weak:true)
}


// ----------------------------------------------------------
// Листинг программного кода (по версии Маркова, в СТП к
// сожалению нет НИ СТРОЧКИ ПРО ЛИСТИНГ КОДА).
//
// Обязательные аргументы: 
//  - body: непосредственно программный код
//  - caption: название листинга
// 
// Последним аргументом используется содержание приложения. 
// Пример использования: 
//
// ````
// #stp2024.listing[Пример программы на языке Python][
//  ```
//    def main():
//      print("Love me some СТП in the mornin'")
//
//    if __name__ == "__main__":
//      main()
//  ```
// ]
// ````
// ----------------------------------------------------------
#let listing(caption, body) = figure(
  body,
  caption: caption,
  kind: code_kind,
  supplement: "Листинг"
)


// ----------------------------------------------------------
// Блок без выравнивания под 1.25, сделан для титульника
// по Гриценко (как я видел у сдавших)
//
// Обязательные аргументы: 
//  - body: текст
// 
// Пример использования: 
//
// ````
// #stp2024.no_indent_block(
//  align(left)[
//    Факультет компьютерных систем и сетей
//    #v(0.3em)
//    Кафедра Информатики
//    #v(0.3em)
//    Дисциплина  "Методы трансляции"
//  ]
// )
// ````
// ----------------------------------------------------------
#let no_indent_block(body) = block({
  set par(first-line-indent: 0em)
  body
})
