#import "lib/stp2024.typ"
#show: stp2024.template

#include "Title.typ"

// Обычно после титульника идут два листа с заданием,
// поэтому страница с содержанием является 4-й по номеру
#counter(page).update(4)

#stp2024.full_outline()

// Ненумерованный заголовок, расположенный по центру
// Такие по СТП требуются для введения, содержания, заключения.
#stp2024.heading_unnumbered[Введение]

// Наполняем содержание текстом с помощью функции lorem
#lorem(200)

#lorem(30)

// Нумерованное перечисление
+ #lorem(20)
+ #lorem(30)
// Пример ссылки на литературный источник (имя определяется в файле 
// bibliography.bib).
+ #lorem(10)@esp32_datasheet

#lorem(50)

= Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod

== Lorem ipsum dolor

#lorem(70)

// Пример картинки
#figure(
  caption : [Думай о карьере],
  image(
    width:50%,
    "img/karjera.jpg"
  )
)

// Пример ссылки на литературный источник (имя определяется в файле 
// bibliography.bib).
#lorem(20)@physics

// Простое ненумеруемое перечисление 
- #lorem(5)
- #lorem(10)
- #lorem(3)

== Lorem ipsum dolor

#lorem(50)

=  At etiam Athenis, ut e patre audiebam facete et urbane toicos irridente, statua est in quo a nobis 

#lorem(20)

== Lorem ipsum dolor sit amet

// Ссылка на уравнение
#lorem(30) Например, в уравнении @eq.

// Уравнение с названием для ссылки на него
$ sum_(n=0)^infinity 1/(n^2) = pi^2/6 $ <eq>

== Lorem ipsum dolor sit amet

На рисунке @einstein расположен #lorem(30)

// Ещё пример рисунка со ссылкой на него
#figure(
  caption : [Альберт Эйнштейн],
  image(
    width:50%,
    "img/einstein.jpg"
  )
) <einstein>

#lorem(10)


= Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod

== Lorem ipsum

//Пример оформления пунктов
=== Punkt 1.
//Здесь нельзя оставить пустую строку, потому что будет разрыв абзаца
#lorem(40)

=== Punkt 2.
#lorem(40) (см. рисунок @kursach)

// Рисунок со ссылкой 
#figure(
  caption : [Курсач],
  image(
    width:45%,
    "img/kursach.jpg"
  )
) <kursach>

=== Punkt 3.
См. таблицу @tbl1

// Длинная таблица, расположенная на нескольких страницах, 
// со ссылкой на неё.
#figure(
  caption : [#lorem(20)],
  kind:table,
  stp2024.longtable(
    columns:(1fr,1fr,1fr),
    table.header(
      [#lorem(2)], [#lorem(2)], [#lorem(2)],
    ),
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
  )
) <tbl1>

== Lorem ipsum dolor sit amet

#lorem(30)

// Перечисление, нумеруемое буквами русского алфавита
#stp2024.abclist(
  [#lorem(20)],
  [#lorem(10)],
  [#lorem(30) на рисунке @kreslo]
)


#pagebreak()
#stp2024.heading_unnumbered[Заключение]

#lorem(100)

#lorem(100)

#lorem(100)

// Список источников, содержащий источники из файла bibliography.bib
#bibliography("bibliography.bib")

#stp2024.appendix(type:[обязательное], title:[Листинг программного кода])[
  ```
#include <stdio.h>
int main() {
	printf("Lorem ipsum dolor sit amet");
}
  ```
]

#stp2024.appendix(type:[обязательное], title:[#lorem(10)])[

  // Пример рисунка в приложении
  #figure(
    caption : [Надо сесть и подумать],
    image(
      width:50%,
      "img/podumat.jpg"
    )
  ) <kreslo>


  // Таблица в приложении
  #figure(
    caption : [#lorem(20)],
    kind:table,
    table(
      columns:(1fr,1fr,1fr),
      table.header(
        [#lorem(2)], [#lorem(2)], [#lorem(2)],
      ),
      [#lorem(4)], [#lorem(7)], [#lorem(12)],
      [#lorem(4)], [#lorem(7)], [#lorem(12)],
    )
  ) <tbl2>

]





