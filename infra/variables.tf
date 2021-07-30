variable "prefix" {
  type        = string
  default     = "rdmaws"
  description = "Prefix that will be used for naming resources. Stands for redmine-aws"
}

variable "project" {
  default = "redmine-aws"
}
