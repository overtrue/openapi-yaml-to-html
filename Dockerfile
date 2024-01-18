FROM alpine:latest

WORKDIR /tmp

ENV PLUGIN_YAML_PATH "openapi.yaml"
ENV PLUGIN_TITLE "OpenAPI"
ENV PLUGIN_OUTPUT_PATH "api.html"
ENV PLUGIN_TEMPLATE "swagger"

RUN apk add yq

ADD . .
ADD entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT /bin/entrypoint.sh

CMD [$PLUGIN_YAML_PATH, '-t', $PLUGIN_TITLE, '-o', $PLUGIN_OUTPUT_PATH, '--template', $PLUGIN_TEMPLATE]
