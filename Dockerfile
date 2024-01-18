FROM --platform=linux/amd64 alpine:latest

ENV PLUGIN_INPUT "openapi.yaml"
ENV PLUGIN_TITLE "OpenAPI"
ENV PLUGIN_OUTPUT "api.html"
ENV PLUGIN_TEMPLATE "swagger"

RUN apk add yq

ADD . /data/plugin-stubs
ADD entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT /bin/entrypoint.sh

CMD [$PLUGIN_INPUT, '-t', $PLUGIN_TITLE, '-o', $PLUGIN_OUTPUT, '--template', $PLUGIN_TEMPLATE]
