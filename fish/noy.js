const child_process = require('child_process');
const fs = require('fs');

let data = fs.readFileSync('package.json', 'utf8')
data = JSON.parse(data);
data = data.scripts
data = Object.keys(data)
data = data.sort()

const fzfCmd = 'fzf --layout=reverse --bind=esc:abort --height=20 --scheme=history --bind esc:'
const result = child_process.execSync(
  `echo "${data.join('\n')}" | ${fzfCmd}`,
  { encoding: "UTF-8" },
)
console.log(result);
