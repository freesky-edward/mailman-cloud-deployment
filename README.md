# mailman-cloud-deployment

This is a repository houses the best practice deploying mailman on public clouds base on the theory ***[newto.me](http://newto.me/tech/) mailman on k8s posts***. Currently,will provide the deployment on [huaweicloud](https://www.huaweicloud.com), later I will try to support more public cloud provider.

***Note***: This repository only provide the classic deployment for miniumx resource runtime, for your workload please following the [configuration](#configuration) to change the infrastructure.

***Note***: This deployment will only consider the common case instead of every case. but it is not difficult to adapte your case with little change base on this deployment.


### Prerequisite

1. ***Cloud account***. please configuration the ```provider.tf``` with your account information
  user_name   = "username"     #The user name of your account
  password    = "password"     #The password of your account
  auth_url    = "https://iam.<region>.myhuaweicloud.com/v3" #Change region that you are going to run in.
  region      = "region"       #The region name where are you going to run. e.g. ap-southeast-1
  tenant_name = "project"      #The project name of your account. also named tenant name.
  domain_name = "domain"       #The account name.

2. ***DNS domain***. the domain information provide by DNS ISP. e.g. godaddy.
   2.1. please login your dns management console. change the DNS server as:
        - ns1.hwclouds-dns.net 
        - ns1.hwclouds-dns.com

3. ***Key Pair***. which is used to access the CCE(kubernetes cluster) node.
   3.1. go the the keypair service console. create one pair with name ```KeyPair-mail``` as default.
   ***note***. you can name the paire whatever you want. just to make sure keep the actual value the same as ```keypair``` variable in ***[var.tf](./infra/huaweicloud/vars.tf)*** by ```-var 'keypair=<your-name>'```.

4. ***Authentication service for CCE***. 
   go to cce(huaweicloud k8s service) console and make sure the cce page which region you are going to setup work well.

5. ***DKIM keys***

   5.1. Generate public key and private key
        ```
        openssl genrsa -out example.com-private.pem 1024 -outform PEM
        openssl rsa -in example.com-private.pem -out example.com.pem -pubout -outform PEM
        ```

        ***note***. Change ```example.com``` to your domain name

   5.2. Configuration the ```dkim_public_key``` with example.com.pem content by ```-var 'dkim_public_key=''```

### Setup the infrastruture

Run the terraform command

```
terraform init
terraform apply -var "domain=<your-domain>" -var "email=<your-email>" -var "dkim_public_key=<your-public-key>"
```

### Setup the mail system

TODO 
