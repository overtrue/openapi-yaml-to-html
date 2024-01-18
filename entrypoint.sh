#!/bin/sh

# 初始化变量
yaml_path="${1:-$PLUGIN_YAML_PATH}"
title="$PLUGIN_TITLE"
output_path="$PLUGIN_OUTPUT_PATH"
template="$PLUGIN_TEMPLATE"

shift

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--title)
            title="$2"
            shift 2
            ;;
        -o|--output)
            output_path="$2"
            shift 2
            ;;
        --template)
            template="$2"
            shift 2
            ;;
        *)
            echo "Error: Invalid parameter: $1" >&2
            echo "Usage: $0 yaml_path [--title title] [--output output_file]" >&2
            exit 1
            ;;
    esac
done

# 检查所有必需的参数是否已提供
if [ -z "$yaml_path" ] ; then
    echo "Error: Missing required parameter" >&2
    echo "Usage: $0 yaml_path [-t title] [-o output_path]" >&2
    echo "Options:" >&2
    echo "  -t, --title TITLE     The title for the output(Default: OpenAPI)." >&2
    echo "  -o, --output FILE     The output file for the HTML(Default: api.html), eg: -o output.html." >&2
    exit 1
fi

if [ -z "$template" ] ; then
    template="swagger"
fi

# 文件存在检测
if [ ! -f "$yaml_path" ]; then
    echo "Error: File not found: $yaml_path" >&2
    exit 1
fi

echo "Load Yaml contents from path: $yaml_path"

# 渲染
# 使用 yq 讲 yaml 转换为 json
yq -o=json $yaml_path >> output.json

# shell 将得到的 json 替换 templates/$template.html 种的 {{definition}}

# 对变量进行转义
escaped_title=$(printf '%s\n' "$title" | sed 's:[\/&]:\\&:g;$!s/$/\\/')
escaped_definition=$(tr -d '\n' < output.json | sed 's:[\/&]:\\&:g;$!s/$/\\/')

sed -E "s/\{\{TITLE\}\}/$escaped_title/g;s/\{\{DEFINITION\}\}/$escaped_definition/g" ./templates/$template.html > $output_path

echo "Success: $output_path"

