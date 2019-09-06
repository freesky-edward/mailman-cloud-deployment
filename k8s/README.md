# K8S manifests

This folder houses the mailman deployment manifests. which include the:

- namespace
- services
- storges (PV)
- workloads(deployment, statefulset)
- configuration(configmap, secrets)

five parts. each resource was written in template with ```{{``` ```}}``` syntax.please replace them before executing.


### Configuration

1. mailman-configmap.yaml

  ```mailman-domain```: The domain name where are you doing to run. e.g. newto.me, example.org
  ```mailman-mta-domain```: The domain where to run mailman MTA(exim4). it is always a sub-domain of mailman-domain. e.g. mail.newto.me
  ```mailman-web-domain```: The domain where to run mailman web. it is always a sub-domain of mailman-domain. e.g. web.newto.me.
  ```mailman-dkim-selector```: A string to mark the DKIM. whatever string you want but be sure the same as DNS record configuration name. e.g. ```20191010```._domainkey.
  ```mailman-dkim-private-key-file```: The DKIM key file name. please refer to [root README](../README.md) for generating DKIM keys. e.g. newto.me-private.pem


2. mailman-core.yaml
  
  ```mailsecret```: The ```secret``` map keep the hyperkitty API key and secret key which are in base64 format.

3. mailman-mta.yaml

  ```mailman-exim4-elb-id```: The load balance id of service. now it only support huaweicloud ELB service.
  ```mailman-exim4-eip```: The internet ip address for exim4. e.g. 1.2.3.4

  ```dkimsecret```: The ```secret``` map house the DKIM private key file. 

  ***note***, we recommend to create the secret from the private file generating in [root README](../README.md)

  ```
  kubectl create secret generic dkimsecret --from-file <private-key-file> -n mail
  ```

4. mailman-web.yaml

  ```mailman-web-elb-id```: The load balance id of web service. 
  ```mailman-web-eip```: The internet ip address for web.
  ```mailman-web-admin-user```: The root user name of web system, configuration whatever you want for first login.
  ```mailman-web-admin-email```: The root users email address for system init.
  ```mailman-web-domain```: The same as above.
  
  ```mailcertsecret```: The secret for SSl certificate file 
  ```mailsecret```: The ```secret``` map keep the hyperkitty API key and secret key which are in base64 format.


