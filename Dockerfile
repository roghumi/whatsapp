FROM golang:1-alpine3.15 AS builder

RUN apk add --no-cache git ca-certificates build-base su-exec olm-dev

COPY . /build
WORKDIR /build
RUN go build -buildvcs=false -o /usr/bin/mautrix-whatsapp

FROM alpine:3.15

ENV UID=1337 \
    GID=1337

RUN apk add --no-cache ffmpeg su-exec ca-certificates olm bash jq yq curl

COPY --from=builder /usr/bin/mautrix-whatsapp /usr/bin/mautrix-whatsapp
COPY --from=builder /build/example-config.yaml /opt/mautrix-whatsapp/example-config.yaml
COPY --from=builder /build/docker-run.sh /docker-run.sh
VOLUME /data

CMD ["/docker-run.sh"]
