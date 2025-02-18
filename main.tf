provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAEXAMPLE"       
  secret_key = "secretKeyExample"  
}

resource "aws_ecs_cluster" "test_cluster" {
  name = "test-ecs-cluster"
}

resource "aws_ecs_task_definition" "test_task" {
  family                   = "test-task"
  network_mode             = "bridge"
  container_definitions    = <<EOF
[
  {
    "name": "test-container",
    "image": "nginx:latest",
    "cpu": 10,          // Bug: Improper CPU units configuration
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0   // Bug: Using dynamic host port mapping may cause issues
      }
    ]
  }
]
EOF
  requires_compatibilities = ["EC2"]
}
