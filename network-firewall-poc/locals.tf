locals {
  subnets = {
    private = {
      ap-southeast-3a = "10.0.1.0/24"
      ap-southeast-3b = "10.0.2.0/24"
      ap-southeast-3c = "10.0.3.0/24"
    }
    public = {
      ap-southeast-3a = "10.0.11.0/24"
      ap-southeast-3b = "10.0.12.0/24"
      ap-southeast-3c = "10.0.13.0/24"
    }
    firewall = {
      ap-southeast-3a = "10.0.21.0/24"
      ap-southeast-3b = "10.0.22.0/24"
      ap-southeast-3c = "10.0.23.0/24"
    }
  }
}
