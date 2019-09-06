# Docker file for mailman key components

There are three key components docker iamges.

- core : mailman-core
- web:   mailman-web
- exim4: mailman-mta

The ```core``` and ```web``` dockerfiles are from [docker-mailman](https://github.com/maxking/docker-mailman) without any updates. I recommend to update the newest version from there unless do update according to my solution later.

The ```exim4``` docker files is from github project but maintained by [tommylike](https://github.com/tommylike) with some part of modification.

So, we recommend to use the original images for core and web. but use this maintains for exim4 image which I publish one in ```slob/exim4:v0.0.1``` on docker hub.



