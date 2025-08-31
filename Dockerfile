FROM golang:1.24-alpine3.21 AS builder

WORKDIR /app
COPY pipeline/gotmpl .
RUN CGO_ENABLED=0 go build -o gotmpl -ldflags="-s -w" .

FROM gcr.io/distroless/static-debian12:debug
WORKDIR /app
COPY --from=builder /app/gotmpl /app/gotmpl

ENTRYPOINT ["/app/gotmpl"]
