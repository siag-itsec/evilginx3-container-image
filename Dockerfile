FROM golang:alpine

ARG BUILD_RFC3339="1970-01-01T00:00:00Z"
ARG COMMIT="local"
ARG VERSION="v3.0.0"

ENV GITHUB_USER="kgretzky"
ENV EVILGINX_REPOSITORY="github.com/${GITHUB_USER}/evilginx2"
ENV INSTALL_PACKAGES="git make gcc musl-dev"
ENV PROJECT_DIR="${GOPATH}/src/${EVILGINX_REPOSITORY}"
ENV EVILGINX_BIN="/bin/evilginx"

RUN mkdir -p ${GOPATH}/src/github.com/${GITHUB_USER} \
    && apk add --no-cache ${INSTALL_PACKAGES} \
    && git -C ${GOPATH}/src/github.com/${GITHUB_USER} clone https://github.com/${GITHUB_USER}/evilginx2 
    
#RUN sed -i '407d;183d;350d;377d;378d;379d;381d;580d;566d;1456d;1457d;1458d;1459d;1460d;1461d;1462d' ${PROJECT_DIR}/core/http_proxy.go
RUN set -ex \
        && cd ${PROJECT_DIR}/ && go get ./... && make \
		&& cp ${PROJECT_DIR}/build/evilginx ${EVILGINX_BIN} \
		&& apk del ${INSTALL_PACKAGES} && rm -rf /var/cache/apk/* && rm -rf ${GOPATH}/src/*

COPY ./entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
		
ENTRYPOINT ["/opt/entrypoint.sh"]
EXPOSE 443

STOPSIGNAL SIGKILL

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Evilginx3 Podman" \
  org.label-schema.description="Evilginx3 Podman Build" \
  org.label-schema.url="https://infosec.ch/" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://infosec.ch/" \
  org.label-schema.vendor="Infosec AG" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"
