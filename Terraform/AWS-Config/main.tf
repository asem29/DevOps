
module "S3" {
  source = "./Modules/S3"
  
}


module "IAM" {
  source = "./Modules/IAM"
  S3 = module.S3.name
  
}
module "AWS-Config" {
  source = "./Modules/AWS-Config"
  S3 = module.S3.name
  IAM_Role = module.IAM.arn_iam


} 