FROM registry.redhat.io/rhscl/php-73-rhel7:1-16

USER 0

COPY ol7-temp.repo /etc/yum.repos.d/ol7-temp.repo

ENV ORACLE_CLIENT_VERSION="19.6"
ENV ORACLE_HOME=/usr/lib/oracle/${ORACLE_CLIENT_VERSION}/client64
ENV LD_LIBRARY_PATH=${ORACLE_HOME}/lib

RUN set -xe && \
    echo "ORACLE_HOME=${ORACLE_HOME}" && \
# add oracle repo https://yum.oracle.com/getting-started.html
    wget https://yum.oracle.com/RPM-GPG-KEY-oracle-ol7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle && \
    gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle && \
# install oracle php packages: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
    yum -y install oracle-release-el7 && yum-config-manager --enable ol7_oracle_instantclient && \
# install oracle-instantclient
    yum -y install oracle-instantclient${ORACLE_CLIENT_VERSION}-basic && \
    yum -y install oracle-instantclient${ORACLE_CLIENT_VERSION}-devel && \
    # yum -y install oracle-instantclient${ORACLE_CLIENT_VERSION}-sqlplus && \
    # FIXME: try to install pcre2-utf32 and pcre2-devel with a yum repo
    yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/pcre2-utf32-10.23-2.el7.x86_64.rpm && \
    yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/pcre2-devel-10.23-2.el7.x86_64.rpm && \
    yum -y install rh-php73-php-devel && \
    echo "instantclient,${ORACLE_HOME}/lib" | pecl install oci8-2.2.0 && \
    echo "extension=oci8.so" > ${PHP_SYSCONF_PATH}/php.d/oci8.ini && \
    yum clean all

USER 1001
