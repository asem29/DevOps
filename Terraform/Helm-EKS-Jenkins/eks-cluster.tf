data "aws_eks_cluster" "dev-cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "dev-cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.dev-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.dev-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.dev-cluster.token
  #load_config_file       = false
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "dev-cluster"
  cluster_version = "1.22"
  subnet_ids     = [aws_subnet.dev1-subnet.id,aws_subnet.dev2-subnet.id]
  vpc_id          = aws_vpc.dev-vpc.id

# If the instance is too small, you will not have enough available NICs to assign IP addresses to
# all the pods on your instances
 # eks_managed_node_group_defaults = [
 #   {
  #    name = "dev-worker-group-1"
  #    instance_type = "t2.small"
  #    asg_min_size = 1
  #    asg_desired_capacity = 2
   #   asg_max_size  = 3
   #   additional_security_group_ids = [aws_security_group.allow-web-traffic.id]
   # }
  #]

eks_managed_node_groups = {
 one = {
   name = "node-group-1"

   instance_types = ["t3.small"]

   min_size     = 1
   max_size     = 3
   desired_size = 2

   pre_bootstrap_user_data = <<-EOT
   echo 'foo bar'
   EOT

   vpc_security_group_ids = [
     aws_security_group.allow-web-traffic.id
   ]
 }

 two = {
   name = "node-group-2"

   instance_types = ["t3.medium"]

   min_size     = 1
   max_size     = 2
   desired_size = 1

   pre_bootstrap_user_data = <<-EOT
   echo 'foo bar'
   EOT

   vpc_security_group_ids = [
     aws_security_group.allow-web-traffic.id
   ]
 }
}


}
