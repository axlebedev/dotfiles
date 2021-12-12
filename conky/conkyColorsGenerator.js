// Результат должен получиться таким
// template2 ${if_match ${\1 \2}<10}A14DA0${else}${if_match ${\1 \2}<20}227DC4${else}${if_match ${\1 \2}<35}ADCBFF${else}${if_match ${\1 \2}<55}EDBD50${else}${if_match ${\1 \2}<70}ED7450${else}${if_match ${\1 \2}<80}ED5057${else}ED5057${endif}${endif}${endif}${endif}${endif}${endif}
//
// Это входной параметр
// const colors = [
//   '#D4909B',
//   '#A14DA0',
//   '#227DC4',
//   '#ADCBFF',
//   '#EDBD50',
//   '#ED7450',
//   '#ED5057',
// ]

const errorColor = '#C42021';
const colors = [
'#FF104F',
'#FF0A73',
'#FF0296',
'#FE20BB',
'#FE50E1',
'#F46EFE',
'#C041F6',
'#8D15EE',
'#6004C8',
'#38048F',
].reverse()
const textColor = '#ADCBFF'

//
//
//
//
//
//
//
//
//
//
//
//
//

const start = 'template2 '

// '${if_match ${\\1 \\2}} < TICK}COLORWITHOUTSHARP${else}'
const beginArrayItem = '${if_match ${\\1 \\2}<TICK}COLOR${else}'
const endArrayItem = '${endif}'
export const getTemplateWithColors = () => {
  const beginArray = []
  const endArray = []

  let result = ''
  for (let i = 0; i < colors.length; ++i) {
    const color = colors[i].slice(1)
    if (i === colors.length - 1) {
      result += color
      continue
    }

    const tick = Math.round(100 / colors.length * (i + 1))
    result += beginArrayItem.replace('TICK', tick).replace('COLOR', color)
  }
  result += Array(colors.length).join(endArrayItem)

  return result;
}

const templateWithColors = getTemplateWithColors()
console.log(templateWithColors)

// example
// {
//   "full_text" : "▇",
//   "color" : "\#ADCBFF",
//   },
export const getExamples = () => {
  return colors.reduce((acc, cur) => {
    return [
      ...acc,
      `{"full_text":"▇","color":"\\${cur}","separator":false}`
    ]
  }, []).join(',') + ','
}
console.log(getExamples())
