FROM golang:1.23.2-alpine3.20 AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git=2.45.2-r0

ENV USER=appuser
ENV UID=10001

# See https://stackoverflow.com/a/55757473/12429735RUN
RUN adduser \
    # disable password login
    --disabled-password \
    # evict full name 
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR $GOPATH/src/github.com/luisfelipecunhaduarte/devsecops-connect/container-hardening

COPY . .

# Fetch dependencies.
RUN go get -d -v \
  && go mod tidy && go mod download \
  && go mod verify

# Build the binary.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/container-hardening

FROM alpine:3.20

RUN apk update && \
    apk add --no-cache libcrypto3=3.3.2-r1 \
    --upgrade && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

# Import the user and group files from the builder.
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Import the compiled executable from the builder.
COPY --from=builder /go/bin/container-hardening /go/bin/container-hardening

# Use an unprivileged user.
USER appuser:appuser

EXPOSE 8080

ENTRYPOINT [ "/go/bin/container-hardening" ]