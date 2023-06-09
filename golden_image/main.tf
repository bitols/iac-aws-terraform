resource "null_resource" "packer_build" {

  provisioner "local-exec" {
    command     = "packer build -var 'region=${var.Region}' -var 'name=${var.Name}' -var 'date=${var.Date}' -var 'manifest_path=${var.Manifest_path}' packer.json"
    working_dir = path.module

  }
}

data "local_file" "manifest" {
  depends_on = [null_resource.packer_build]
  filename = var.Manifest_path

}