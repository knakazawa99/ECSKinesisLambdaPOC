FROM golang:1.20.4-alpine3.18 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN GOOS=linux GOARCH=amd64 go build -o main ./apps/event/cmd/main.go

FROM public.ecr.aws/lambda/go:1

COPY --from=builder /app/main ${LAMBDA_TASK_ROOT}

CMD [ "main" ]
