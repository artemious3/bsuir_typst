// За подробной информацией обращаться к документации
// Typst и lib/stp2024.typ

#import "lib/stp2024.typ"
 // Применить стиль оформления по СТП
#show: stp2024.template

// Титульник курсового проекта
// Меняем под себя, если нужно
#include "01_titulnik.typ"

// 2 - задание (2 стр)

// 3 - реферат

#counter(page).update(5)
// Полное содержание, которое включает приложения
// Обычный #outline приложения не включает
#stp2024.full_outline()

#include "04_terminy.typ"

#include "06_vvedenie.typ"


#include "07_analiz_istochnikov.typ"

#include "08_model_trebovania.typ"

#include "09_proektirovanie.typ"

#include "10_razrabotka.typ"

#include "11_testirovanie.typ"

#include "12_rukovodstvo.typ"

#include "13_teo.typ"

#include "14_zakluchenie.typ"


// Список источников, содержащий источники из файла bibliography.bib
#bibliography("bibliography.bib")

#include "15_prilozheniya.typ"


