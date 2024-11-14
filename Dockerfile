FROM --platform=linux/amd64 node:20

ENV PLUGIN_INPUT "openapi.yaml"
ENV PLUGIN_TITLE "OpenAPI"
ENV PLUGIN_OUTPUT "api.html"
ENV PLUGIN_TEMPLATE "swagger"

RUN npm run i

ADD . /data/plugin-stubs
ADD entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

CMD ['node', 'replace.js', '-t', $PLUGIN_TITLE, '-o', $PLUGIN_OUTPUT, '--template', $PLUGIN_TEMPLATE, $PLUGIN_INPUT]
