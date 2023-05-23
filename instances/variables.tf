variable "network" {
  description = "Network module output"
}

variable "image" {
  description = "Golden_Image module output"
}

variable "name" {
  description = "Name value for tags or resources"
  type        = string
}

variable "tags" {
  description = "Tags to be defined on resources"
  type        = map(string)
}