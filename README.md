# s2i-php-oci

This is a repo to create an Openshift RedHat Source-to-Image (s2i) with PHP and OCI8 (Oracle client) using the base image registry.redhat.io/rhscl/php-73-rhel7.

base image : https://catalog.redhat.com/software/containers/detail/5da02265dd19c70159f46017?container-tabs=overview


s2i: 
* https://github.com/openshift/source-to-image
* https://docs.openshift.com/container-platform/3.11/creating_images/s2i.html
* php s2i : https://docs.openshift.com/container-platform/3.11/using_images/s2i_images/php.html



build the source image
```
docker build -t sokubedocker/php-73-rhel7-oci .
```

build s2i image:
```
s2i build -c . sokubedocker/php-73-rhel7-oci myphp
```

Test using:
```
docker run -p 8080:8080 --rm -it myphp
```
