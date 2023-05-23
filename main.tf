provider "aws" {
  region = var.Region  
}

# #Módulo Network
module "network" {
  source = "./network" 
  Network_CIDR = var.Network_CIDR
  N_subnets    = var.N_subnets
  Name         = var.Vpc_Name
}

# Módulo Golden_Image
module "golden_image" {
  source = "./golden_image"
  Manifest_path = var.Image_Manifest_path

}

# Módulo Instances
module "instances" {
  depends_on = [module.network.network, module.golden_image.manifest]
  source  = "./instances"
  name    = var.name
  tags    = var.tags
  network = module.network.network
  image   = module.golden_image.manifest
}