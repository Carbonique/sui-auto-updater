FROM golang:1.22-alpine AS build

WORKDIR /build
COPY go.mod go.sum *.go ./

RUN go mod download

RUN CGO_ENABLED=0 go build -o sui-auto-discovery

FROM alpine:3.19

WORKDIR /app

COPY --from=build /build/sui-auto-discovery sui-auto-discovery
COPY ./config/cronjobs /etc/crontabs/root

# start crond with log level 8 in foreground, output to stderr
CMD ["crond", "-f", "-d", "8"]
