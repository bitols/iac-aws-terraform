provider "aws" {
  region = var.Region  
}

#Módulo Network
module "network" {
  source = "./network" 
  Network_CIDR = var.Network_CIDR
  N_subnets    = var.N_subnets
  Name         = var.Vpc_Name
}

# Módulo Golden_Image
module "golden_image" {
  source = "./golden_image"
  Region        = var.Region  
  Name          = var.Image_Name
  Date          = var.Image_Date
  Manifest_path = var.Image_Manifest_path

}
