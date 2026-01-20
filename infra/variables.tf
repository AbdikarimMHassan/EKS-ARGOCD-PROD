variable "my_ip" {
  description = "restrict cluster_endpoint_public_access to my ip"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}