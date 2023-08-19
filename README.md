## ECS + Kinesis + Lambda 検証用

> docker build --platform=linux/amd64 -t ecs-kinesis-lambda-poc-api-ecr:1 --no-cache .
> docker buildx build --platform linux/amd64 -t ecs-kinesis-lambda-poc-fluentbit .


> terraform init
> terraform apply