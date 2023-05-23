Region = "us-west-2"

Network_CIDR = "10.0.0.0/16"
N_subnets = 4
Vpc_Name = "my-vpc"

Image_Manifest_path  = "./golden_image/manifest.json"

name = "my-ec2"
tags = {
  "date" = "2023-05-22"
}