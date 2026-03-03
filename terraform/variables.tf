variable "cluster_name" {
  default = "devsecops-eks-cluster"
}

variable "vpc_id" {
  default = "vpc-08571db43668982d7"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-018c14194afafca67",
    "subnet-073e58ffe3ba9b135"
  ]
}