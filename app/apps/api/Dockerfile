FROM golang:1.20.4-alpine3.18 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN GOOS=linux GOARCH=amd64 go build -o api ./apps/api/cmd/server.go

FROM alpine:3.18

COPY --from=builder /app/api .

EXPOSE 8080
ENTRYPOINT ["./api"]
