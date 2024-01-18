#!/bin/sh

set -xe

# 初始化变量
input="${1:-$PLUGIN_INPUT}"
title="$PLUGIN_TITLE"
output="$PLUGIN_OUTPUT"
template="$PLUGIN_TEMPLATE"

if [ $# -gt 0 ] ; then
    shift
fi

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--title)
            title="$2"
            shift 2
            ;;
        -o|--output)
            output="$2"
            shift 2
            ;;
        --template)
            template="$2"
            shift 2
            ;;
        *)
            echo "Error: Invalid parameter: $1" >&2
            echo "Usage: $0 api.yaml [--title title] [--output output_file]" >&2
            exit 1
            ;;
    esac
done

# 检查所有必需的参数是否已提供
if [ -z "$input" ] ; then
    echo "Error: Missing required parameter" >&2
    echo "Usage: $0 input.yaml [-t title] [-o output]" >&2
    echo "Options:" >&2
    echo "  -t, --title TITLE     The title for the output(Default: OpenAPI)." >&2
    echo "  -o, --output FILE     The output file for the HTML(Default: api.html), eg: -o output.html." >&2
    exit 1
fi

if [ -z "$template" ] ; then
    template="swagger"
fi

# 文件存在检测
if [ ! -f "$input" ]; then
    echo "Error: File not found: $input" >&2
    exit 1
fi

echo "Load Yaml contents from path: $input"

# 渲染
# 使用 yq 讲 yaml 转换为 json
yq -o=json $input >> /tmp/output.json

# shell 将得到的 json 替换 templates/$template.html 种的 {{definition}}

# 对变量进行转义
escaped_title=$(printf '%s\n' "$title" | sed 's:[\/&]:\\&:g;$!s/$/\\/')
escaped_definition=$(tr -d '\n' < /tmp/output.json | sed 's:[\/&]:\\&:g;$!s/$/\\/')

# 命令太长了，写入文件
echo "s/\{\{TITLE\}\}/$escaped_title/g;s/\{\{DEFINITION\}\}/$escaped_definition/g" > /tmp/replace.sed

sed -E -f /tmp/replace.sed /data/plugin-stubs/templates/$template.html > $output

echo "Success: $output"

