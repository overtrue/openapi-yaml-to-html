# OpenAPI yaml to html

openapi to yaml 是一个 oci 插件，用于将 openapi yaml 文件转换为 html 文件。

## 使用

流水线配置示例：

```yaml
  - name: 渲染 API 文档
    image: overtrue/openapi-yaml-to-html:1.0.3
    settings:
      input: ./docs/api.yaml # openapi yaml 文件路径
      output: ./public/docs.html  # html 文件输出路径
      title: API 文档
      template: stoplight-elements # 模板，目前可选：swagger(默认)/stoplight-elements
```
