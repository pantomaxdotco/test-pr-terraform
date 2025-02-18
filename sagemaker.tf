resource "aws_iam_role" "sagemaker_role" {
  name = "SageMakerExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_policy_attachment" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_model" "test_model" {
  name               = "test-model"
  execution_role_arn = aws_iam_role.sagemaker_role.arn

  primary_container {
    image          = "123456789012.dkr.ecr.us-east-1.amazonaws.com/inference:latest" 
    model_data_url = "s3://public-test-bucket-123/model.tar.gz"
  }
}

resource "aws_sagemaker_endpoint_config" "test_endpoint_config" {
  name = "test-endpoint-config"
  production_variants {
    variant_name             = "AllTraffic"
    model_name               = aws_sagemaker_model.test_model.name
    initial_instance_count   = 1
    instance_type            = "ml.m5.large" 
  }
}

resource "aws_sagemaker_endpoint" "test_endpoint" {
  name                 = "test-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_config.test_endpoint_config.name
}
