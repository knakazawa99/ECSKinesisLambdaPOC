## ECS + Kinesis + Lambda 検証用

> docker build --platform=linux/amd64 -t ecs-kinesis-lambda-poc-api-ecr:1 -f ./apps/api/Dockerfile --no-cache .  
> docker buildx build --platform linux/amd64 -t ecs-kinesis-lambda-poc-fluentbit .  


> GOOS=linux GOARCH=amd64 go build -o main ./apps/event/cmd/main.go  
> docker buildx build --platform linux/amd64 -t ecs-kinesis-lambda-poc-lambda -f ./apps/event/Dockerfile --no-cache .


> terraform init
> terraform apply