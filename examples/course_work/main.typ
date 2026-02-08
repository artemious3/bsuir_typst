// За подробной информацией обращаться к документации
// Typst и lib/stp2024.typ

#import "lib/stp2024.typ"
 // Применить стиль оформления по СТП
#show: stp2024.template

// Титульник курсового проекта
// Меняем под себя, если нужно
#include "Title.typ"

// Обычно после титульника идут два листа с заданием,
// поэтому страница с содержанием является 4-й по номеру
#counter(page).update(4)

// Полное содержание, которое включает приложения
// Обычный #outline приложения не включает
#stp2024.full_outline()

// Ненумерованный заголовок, расположенный по центру
// Такие по СТП требуются для введения, содержания, заключения.
#stp2024.heading_unnumbered[Введение]

// Пишем текст, как в обычном текстовом файле 
Lorem ipsum dolor sit amet...

// Чтобы сделать новый абзац, пропускаем строку
Lorem ipsum dolor sit amet с нового абзаца!

// Далее будем генерировать текст с помощью функции lorem.
#lorem(200)

#lorem(30)

// Нумерованное перечисление
+ #lorem(20)
+ #lorem(30)
// Пример ссылки на литературный источник (имя определяется в файле 
// bibliography.bib).
+ #lorem(10)@esp32_datasheet

#lorem(50)

// Заголовок раздела
= Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod

// Заголовок подраздела
== Lorem ipsum dolor

#lorem(70)

// Пример листинга
#stp2024.listing([
  ```
def main():
  print("Love me some СТП in the mornin'")
  ```
], [Пример программы на языке Python]
)

#lorem(5)


// Пример картинки
#figure(
  // Подпись к картинке
  caption : [Думай о карьере],
  image(
    // Ширина картинки, можно также указать высоту 
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
$ 
 sum_(n=0)^infinity 1/(n^2) = pi^2/6
$ <eq>

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
    // Ширина колонок. В данном случае каждая колонка 
    // равную ширину (см. документацию функции table)
    columns:(1fr,1fr,1fr),
    // Заголовок, который будет повторяться
    table.header(
      [Column 1], [Column 2], [Column 3],
    ),
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
    [#lorem(4)], [#lorem(7)], [#lorem(12)],
  )
) <tbl1>

== Lorem ipsum dolor sit amet

#lorem(30) в листинге @ccode

// Перечисление, нумеруемое буквами русского алфавита
#stp2024.abclist(
  [#lorem(20)],
  [#lorem(10)],
  [#lorem(30) на рисунке @kreslo]
)


// Разрыв страницы перед Заключением
#pagebreak()
// Ненумерованный заголовоко "Заключение"
#stp2024.heading_unnumbered[Заключение]

#lorem(100)

#lorem(100)

#lorem(100)

// Список источников, содержащий источники из файла bibliography.bib
#bibliography("bibliography.bib")

// Пример приложения с листингом кода
#stp2024.appendix(type:[обязательное], title:[Листинг программного кода])[
  #stp2024.listing(
    ```
#include <stdio.h>
int main() {
  printf("Lorem ipsum dolor sit amet");
}
    ```,
[Код на Си #lorem(10)]
  ) <ccode>
]

// Пример приложения с рисунком и таблицей
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





