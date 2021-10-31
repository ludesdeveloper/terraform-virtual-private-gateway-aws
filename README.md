# SITE TO SITE VPN AWS SIMULATION USING OPENSWAN 
Basically i just convert this video [Video Source](https://www.youtube.com/watch?v=Ju4K3K873sw&list=WL&index=2) to terraform code.

## **Requirements**

1. AWS CLI installed and login to AWS account
2. Terraform installed

## **How ?**
Note: This code use ap-southeast-2 for region, you can change it base on your request
1. Clone this repository
```
git clone https://github.com/ludesdeveloper/terraform-virtual-private-gateway-aws.git
```
2. Enter directory
```
cd terraform-virtual-private-gateway-aws 
```
3. Create file name terraform.tfvars for environment variable, input your access_key and also secret_key
```
vim terraform.tfvars
```
```
access_key="your_access_key"
secret_key="your_secret_key"
```
4. Init terraform
```
terraform init
```
5. For check you can use "terraform plan"
```
terraform plan
```
6. To apply, type "terraform apply" and type yes then enter to continue infrasturcture creation
```
terraform apply
```

## **Remote EC2**
For remote EC2 don't forget to chmod 400 for keypair file, then ssh to EC2
```
chmod 400 ec2-for-development
```
