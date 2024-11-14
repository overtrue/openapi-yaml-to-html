const fs = require('fs')
const path = require('path')
const process = require('process')
const yaml = require('js-yaml')
const { program } = require('commander')
const he = require('he')

// 获取命令行参数
const args = process.argv

program
  .arguments('<input>', 'The input file path')
  .option('-t, --title <title>', 'The title for the output (Default: OpenAPI)', 'OpenAPI Docs')
  .option('-o, --output <file>', 'The output file for the HTML (Default: api.html)', 'api.html')
  .option('--template <name>', 'The template name to use (Default: swagger)', 'swagger')
  .parse(args)

console.log('options:', program.opts())

const input = program.args[0] || ''
const { title, output, template } = program.opts()

// 文件存在检测
if (!fs.existsSync(input)) {
  console.error(`Error: File not found: ${input}`)
  process.exit(1)
}

console.log(`Load YAML contents from path: ${input}`)

// 读取 YAML 文件并转换为 JSON
let jsonContent
try {
  const yamlContent = fs.readFileSync(input, 'utf8')
  jsonContent = yaml.load(yamlContent)
} catch (e) {
  console.error(`Error: Failed to parse YAML file: ${input}`)
  process.exit(1)
}

// 渲染 JSON 为 HTML
// 将 JSON 内容转换为字符串并对其进行转义
const escapedTitle = he.encode(title)
const escapedDefinition = JSON.stringify(jsonContent)

// 替换模板中的占位符
const templatePath = path.join(__dirname, `templates/${template}.html`)
if (!fs.existsSync(templatePath)) {
  console.error(`Error: Template file not found: ${templatePath}`)
  process.exit(1)
}

let templateContent
try {
  templateContent = fs.readFileSync(templatePath, 'utf8')
} catch (e) {
  console.error(`Error: Failed to read template file: ${templatePath}`)
  process.exit(1)
}

// 替换模板中的占位符
const outputContent = templateContent
  .replace(/{{TITLE}}/g, escapedTitle)
  .replace(/{{DEFINITION}}/g, escapedDefinition)

try {
  fs.writeFileSync(output, outputContent, 'utf8')
  console.log(`Success: Output written to ${output}`)
} catch (e) {
  console.error(`Error: Failed to write output file: ${output}`)
  process.exit(1)
}
