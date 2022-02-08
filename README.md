AWS set-up with terraform and ansible

Steps to create infrastructure in AWS with current repository

- Create AWS account (if not already created)
- Clone repo
- Fill the necessary variables in credentials file and place it under ~/.aws directory
- Fill the necessary variables in terraform/terraform.tfvars file
- Change directory to terraform folder
- enter terraform init in cli
- enter terraform apply in cli
- install ansible playbooks to created instances