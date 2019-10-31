FROM golang:1.13.3-alpine3.10 as builder
RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates
RUN adduser -D -g '' appuser
WORKDIR $GOPATH/src/nwn-module-dungeoneternalx/disdex/
COPY disdex .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/disdex .
FROM scratch
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/bin/disdex /go/bin/disdex
USER appuser
ENTRYPOINT ["/go/bin/disdex"]