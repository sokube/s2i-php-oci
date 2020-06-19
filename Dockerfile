FROM registry.redhat.io/rhscl/php-73-rhel7:1-17

USER 0

ARG PROXY

COPY ol7-temp.repo /etc/yum.repos.d/ol7-temp.repo

ENV DB2_CLIENT_VERSION="11.5"
ENV DB2_HOME=/opt/ibm

ENV ORACLE_CLIENT_VERSION="19.6"
ENV ORACLE_HOME=/usr/lib/oracle/${ORACLE_CLIENT_VERSION}/client64
ENV LD_LIBRARY_PATH=${ORACLE_HOME}/lib:${DB2_HOME}
ENV https_proxy=${PROXY}
ENV http_proxy=${PROXY}

RUN set -xe && \
    echo "DB2_HOME=${DB2_HOME}" && \
    mkdir -p ${DB2_HOME} && \
    cd ${DB2_HOME} && \
    wget https://pecl.php.net/get/ibm_db2-2.0.8.tgz && \
    wget https://pecl.php.net/get/PDO_IBM-1.3.6.tgz && \
    wget https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/linuxx64_odbc_cli.tar.gz && \
    tar -xzf ibm_db2-2.0.8.tgz && \
    tar -xzf PDO_IBM-1.3.6.tgz && \
    tar -xzf linuxx64_odbc_cli.tar.gz && \
    cd ${DB2_HOME}/clidriver && \
    ln -s ${DB2_HOME}/clidriver/lib ${DB2_HOME}/clidriver/lib64

RUN set -xe && \
    echo "ORACLE_HOME=${ORACLE_HOME}" && \
# Add oracle repo https://yum.oracle.com/getting-started.html
    wget https://yum.oracle.com/RPM-GPG-KEY-oracle-ol7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle && \
    gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle && \
# Install oracle php packages: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
    yum -y install oracle-release-el7 && yum-config-manager --enable ol7_oracle_instantclient && \
# Install oracle-instantclient
    yum -y install oracle-instantclient${ORACLE_CLIENT_VERSION}-basic && \
    yum -y install oracle-instantclient${ORACLE_CLIENT_VERSION}-devel && \
    # to install sqlplus => yum -y install oracle-instantclient${ORACLE_CLIENT_VERSION}-sqlplus && \
# Dependencies needed by phpize
    yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/pcre2-utf32-10.23-2.el7.x86_64.rpm && \
    yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/pcre2-devel-10.23-2.el7.x86_64.rpm && \
    yum -y install rh-php73-php-devel

RUN set -xe && \
# Download PHP source for compiling oci8 and pdo_oci modules
    export PHP_VERSION_FULL=$(php -r "echo PHP_VERSION;") && \
    curl -L https://github.com/php/php-src/archive/php-${PHP_VERSION_FULL}.tar.gz -o php.tar.gz && \
    tar -xvf php.tar.gz && \
# Install OCI8 by compiling https://github.com/php/php-src/tree/PHP-7.1.11/ext/oci8
    cd ${APP_DATA}/php-src-php-${PHP_VERSION_FULL}/ext/oci8/ && \
    phpize && \
    ./configure --with-oci8=instantclient,${ORACLE_HOME}/lib && \
    make install && \
    echo "extension=oci8.so" > ${PHP_SYSCONF_PATH}/php.d/oci8.ini && \
# Install PDO_OCI by compiling https://github.com/php/php-src/tree/PHP-7.1.11/ext/pdo_oci
    cd ${APP_DATA}/php-src-php-${PHP_VERSION_FULL}/ext/pdo_oci/ && \
    phpize && \
    ./configure --with-pdo-oci=instantclient,${ORACLE_HOME}/lib && \
    make install && \
    echo "extension=pdo_oci.so" > ${PHP_SYSCONF_PATH}/php.d/pdo_oci.ini && \
# Install ibm_db2 and PDO_IBM by compiling
    cd ${DB2_HOME}/ibm_db2-2.0.8 && \
    phpize && \
    ./configure --with-IBM_DB2=${DB2_HOME}/clidriver && \
    make && \
    make install && \
    echo "extension=ibm_db2.so" > ${PHP_SYSCONF_PATH}/php.d/ibm_db2.ini && \
    cd ${DB2_HOME}/PDO_IBM-1.3.6 && \
    phpize && \
    ./configure --with-pdo-ibm=${DB2_HOME}/clidriver && \
    make && \
    make install && \
    echo "extension=pdo_ibm.so" > ${PHP_SYSCONF_PATH}/php.d/pdo_ibm.ini && \
# Clean up
    rm -Rf cd ${APP_DATA}/php-src-php-${PHP_VERSION_FULL} && \
    rm ${APP_DATA}/php.tar.gz && \
    rm -f ${DB2_HOME}/linuxx64_odbc_cli.tar.gz && \
    rm -f ${DB2_HOME}/ibm_db2-2.0.8.tgz && \
    rm -f ${DB2_HOME}/PDO_IBM-1.3.6.tgz && \
    rm -Rf ${DB2_HOME}/ibm_db2-2.0.8 && \
    rm -Rf ${DB2_HOME}/PDO_IBM-1.3.6 && \
    yum clean all && \
    php -m | grep oci  && \
    php -m | grep ibm  && \
    php -v

USER 1001
