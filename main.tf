module "kms_key" {
  source     = "./modules/kms-key"
  key_alias  = "my-kms-key"
}

variable "key_alias" {
  description = "The alias to associate with the KMS key"
  type        = string
  default = ""
}

output "kms_key_id" {
  description = "The ID of the KMS key created by the module"
  value       = module.kms_key.kms_key_id
}
