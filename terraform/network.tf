resource "aws_internet_gateway" "ecs_kinesis_lambda_poc_internet_gateway" {
  vpc_id = aws_vpc.ecs_kinesis_lambda_poc.id
}


resource "aws_route_table" "ecs_kinesis_lambda_poc_route_table" {
  vpc_id = aws_vpc.ecs_kinesis_lambda_poc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_kinesis_lambda_poc_internet_gateway.id
  }
  tags = {
    Name = var.tag
  }
}

resource "aws_route_table_association" "ecs_kinesis_lambda_poc_route_table_public_association_a" {
  route_table_id = aws_route_table.ecs_kinesis_lambda_poc_route_table.id
  subnet_id      = aws_subnet.public-subnet-1a.id
  depends_on     = [aws_route_table.ecs_kinesis_lambda_poc_route_table]
}

resource "aws_route_table_association" "ecs_kinesis_lambda_poc_route_table_public_association_c" {
  route_table_id = aws_route_table.ecs_kinesis_lambda_poc_route_table.id
  subnet_id      = aws_subnet.public-subnet-1c.id
  depends_on     = [aws_route_table.ecs_kinesis_lambda_poc_route_table]
}
