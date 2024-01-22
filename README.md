# OpenAPI yaml to html

openapi to yaml 是一个 oci 插件，用于将 openapi yaml 文件转换为 html 文件。

## 使用

流水线配置示例：

```yaml
  - name: 渲染 API 文档
    image: overtrue/openapi-yaml-to-html:1.0.4
    settings:
      input: ./docs/api.yaml        # openapi yaml 文件路径
      output: ./public/docs.html    # 可选，html 文件输出路径，默认为 ./api.html
      title: API 文档                # 可选，默认「OpenAPI」
      template: elements   #  可选，模板，swagger(默认)/elements/redoc
```
