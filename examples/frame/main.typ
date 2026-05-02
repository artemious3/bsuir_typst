#import "lib/stp2024.typ"

#let conf = (
    doc-number: "ГУИР.123456.001 СА",
    title: (
      "Алгоритм простофиля",
    ),
    doc-type: "Схема алгоритма",
    developer: "Ленин",
    reviewer: "Гриб",
    norm-control: "Ленин",
    approver: "Гриб",
    lit: "Т",
    current-page: "1",
    total-pages: "1",
    department-group: "Кафедра приколов, гр. 123456",
)

// По необходимости шрифт можно изменить в аргументе,
// например font: "GOST Type B"

// Рамка отсутствует (stroke:0pt), удобно для обратной стороны плаката
#stp2024.frame(paper:"a4",stroke:0pt, type:"a", config:conf)[]

// Рамка A4
#stp2024.frame(paper:"a4", font:"GOST type B", type:"a", config:conf)[
  // Содержание выровнено по центру горизонтально (center)
  // и вертикально (horizon)
  #place(center+horizon, image("prostofila.jpg", width: 20%))
]

// Рамка A3 (портретная, тип а)
#stp2024.frame(paper:"a3",type:"a", config:conf)[
  // Можно изменять положение с помощью dx, dy
  #place(center+horizon, dx:-20%,image("prostofila.jpg", width: 20%))
]

// Рамка A3 (альбомная, тип а)
#stp2024.frame(paper:"a3",flipped: true, type:"a", config:conf)[
  #place(center+horizon, dx:+20%,image("prostofila.jpg", width: 20%))
]

// Рамка A3 (альбомная, тип б)
#stp2024.frame(paper:"a3",flipped: true, type:"б", config:conf)[
  #place(center+horizon, dy:-20%,image("prostofila.jpg", width: 20%))
]

// Рамка A3 (альбомная, тип в)
#stp2024.frame(paper:"a3",flipped: true, type:"в", config:conf)[
  #place(center+horizon, dy:+20%,image("prostofila.jpg", width: 20%))
]
