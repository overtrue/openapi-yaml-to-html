FROM node:20

ENV PLUGIN_INPUT "openapi.yaml"
ENV PLUGIN_TITLE "OpenAPI"
ENV PLUGIN_OUTPUT "api.html"
ENV PLUGIN_TEMPLATE "swagger"

ADD . /data/plugin-stubs

RUN cd /data/plugin-stubs && npm install

CMD /usr/local/bin/node replace.js -t $PLUGIN_TITLE -o $PLUGIN_OUTPUT --template $PLUGIN_TEMPLATE $PLUGIN_INPUT
