variable "aws_region" {
  description = "AWS region for the infrastructure."
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project identifier."
  type        = string
  default     = "k3s-observability"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "development"
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet."
  type        = string
  default     = "eu-west-1a"
}
