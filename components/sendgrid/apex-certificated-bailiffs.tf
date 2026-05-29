locals {
  certificated_bailiffs_non_prod_domain = ["mail-apex-certificated-bailiffs-nonprod.platform.hmcts.net"]
  certificated_bailiffs_prod_domain = ["mail-apex-certificated-bailiffs.platform.hmcts.net"]
}
module "certificated_bailiffs" {
  source      = "../modules/sendgrid"
  environment = var.env
  account     = "apex-certificated-bailiffs"
  domains     = var.env == "prod" ? local.certificated_bailiffs_prod_domain : local.certificated_bailiffs_non_prod_domain
}
module "certificated_bailiffs_dns" {
  source      = "../modules/azure_dns"
  dns_records = module.certificated_bailiffs.dns_records
  zone_name   = "platform.hmcts.net"
}
