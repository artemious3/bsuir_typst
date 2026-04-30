#import "/lib/stp2024.typ"

#let main-table-conf = (
  documents: (
    (section-title: "Текстовые документы"),
    (
      code: "ГУИР КП 6-05-0612-02 023 ПЗ",
      name-lines: ("Пояснительная записка",),
      note: "50 c.",
    ),
    (section-title: "Графические документы"),
    (
      code: "ГУИР.05061202.023.01",
      name-lines: (
        "Функциональная схема",
        "алгоритма, реализующего",
        "программное средство",
      ),
      note: "Формат А3",
    ),
    (
      code: "ГУИР.05061202.023.02",
      name-lines: (
        "Блок схема алгоритма,",
        "реализующего программное",
        "средство",
      ),
      note: "Формат А3",
    ),
    (
      code: "ГУИР.05061202.023.01 ПЛ",
      name-lines: (
        "Графики сравнения",
        "производительности процессоров",
      ),
      note: "Формат А3",
    ),
    (
      code: "ГУИР.05061202.023.02 ПЛ",
      name-lines: (
        "Графическое представление",
        "нагрузки на ядра процессоров",
      ),
      note: "Формат А3",
    ),
  ),
)

#let left-table-conf = (
  left-doc-number: "ГУИР.ГУИР.353503.023 ПЗ",
)

#let footer-table-conf = (
  doc-number: "ГУИР КП 6-05-0612-02 023 ПЗ",
  title: (
    "Сравнение производительности",
    "процессоров Intel Core i5-12450H и",
    "Amd Ryzen 7 5800H на основе",
    "выполнения преобразований Фурье",
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
  group: "353503",
)

#stp2024.list_of_documents(
  main-table-config: main-table-conf,
  left-table-config: left-table-conf,
  footer-table-config: footer-table-conf,
)
