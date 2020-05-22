# s2i-php-oci


s2i: 
* https://github.com/openshift/source-to-image
* https://docs.openshift.com/container-platform/3.11/creating_images/s2i.html
* php s2i : https://docs.openshift.com/container-platform/3.11/using_images/s2i_images/php.html


other links:
* https://github.com/sclorg/s2i-php-container/blob/master/5.5/Dockerfile
* https://github.com/adbaldi/phpoci8
* http://www.buffalo.edu/ubit/service-guides/web-hosting/webapps/instructions/php-extensions.html


build s2i image:
```
s2i build -c . registry.redhat.io/rhscl/php-70-rhel7 myphp --assemble-user root
```

Test using:
```
docker run -p 8080:8080 --rm -it myphp
```
