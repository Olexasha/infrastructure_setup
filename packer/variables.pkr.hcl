variable "id_catalog" {
    type = string
    default = "b1gqd4jqceu8foa3um2m"
}

variable "id_source_image" {
    type = string
    default = "ubuntu-1604-lts"
}

variable "service_account_key_file_path" {
    type = string
    default = "./files/packer_key.json"
}

variable "use_ipv4_nat" {
    type = bool
    default = true
}
