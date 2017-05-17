### ALPINE LINUX BASED JENKINS INCLUDE ORACLE JDK8
FROM alpine:3.5
MAINTAINER Github:dostroke <isgenez@gmail.com>

ENV JDK_VER=8u131 \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    JENKINS_HOME=/var/lib/jenkins \
    JENKINS_VER=2.46.2 \
    COPY_REFERENCE_FILE_LOG=/var/lib/jenkins/copy_reference_file.log \
    JENKINS_SLAVE_AGENT_PORT=50000

ARG UID=1000
ARG GID=1000
ARG USERNAME=jenkins
ARG GROUPNAME=jenkins
ARG JENKINS_UC=https://updates.jenkins.io

RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates && \
    apk add --no-cache openssh-client git curl unzip bash coreutils openssl && \
    addgroup -g ${GID} ${GROUPNAME} && \
    adduser -h ${JENKINS_HOME} -u ${UID} -G ${GROUPNAME} -G root -s /bin/bash -D ${USERNAME} && \
    mkdir -p /usr/share/jenkins/ref/init.groovy.d
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

RUN set -ex; \
        apkArch="$(apk --print-arch)"; \
        case "$apkArch" in \
                x86_64) dockerArch=x86_64 ;; \
                armhf) dockerArch=armel ;; \
                *) echo >&2 "error: unknown Docker static binary arch $apkArch"; exit 1 ;; \
        esac; \
        curl -fSL "https://get.docker.com/builds/Linux/${dockerArch}/docker-17.03.1-ce.tgz" -o docker.tgz; \
# /bin/sh doesn't support ${!...} :(
        tar -xzvf docker.tgz; \
        mv docker/* /usr/local/bin/; \
        rmdir docker; \
        rm docker.tgz; \
        docker -v 

#############################
### INSTALL GLIBC 2.25-r0 ###
#############################
RUN wget --progress=bar:force https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    -O /etc/apk/keys/sgerrand.rsa.pub && \
    wget --progress=bar:force https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk \
         https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk \
         https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk && \
    apk add --no-cache glibc-2.25-r0.apk glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    apk del glibc-i18n && \
    rm /root/.wget-hsts && \
    rm glibc-2.25-r0.apk glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk
 
########################
### TIMEZONE SETTING ###
########################
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone && \
    date && apk del tzdata

##########################
### DOWNLOAD JDK 8u131 ###
##########################
RUN wget --progress=bar:force --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
    "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz" -O /tmp/jdk-${JDK_VER}-linux-x64.tar.gz && \
    tar -xvf /tmp/jdk-${JDK_VER}-linux-x64.tar.gz -C /tmp/ && \
    mkdir -p /usr/lib/jvm && mv /tmp/jdk1.8.0_131 ${JAVA_HOME} && \
    rm -rf "${JAVA_HOME}/"src.zip && \
    rm -rf "${JAVA_HOME}/lib/missioncontrol" \
           "${JAVA_HOME}/lib/visualvm" \
           "${JAVA_HOME}/lib/"*javafx* \
           "${JAVA_HOME}/jre/lib/plugin.jar" \
           "${JAVA_HOME}/jre/lib/ext/jfxrt.jar" \
           "${JAVA_HOME}/jre/bin/javaws" \
           "${JAVA_HOME}/jre/lib/javaws.jar" \
           "${JAVA_HOME}/jre/lib/desktop" \
           "${JAVA_HOME}/jre/plugin" \
           "${JAVA_HOME}/jre/lib/"deploy* \
           "${JAVA_HOME}/jre/lib/"*javafx* \
           "${JAVA_HOME}/jre/lib/"*jfx* \
           "${JAVA_HOME}/jre/lib/amd64/libdecora_sse.so" \
           "${JAVA_HOME}/jre/lib/amd64/"libprism_*.so \
           "${JAVA_HOME}/jre/lib/amd64/libfxplugins.so" \ 
           "${JAVA_HOME}/jre/lib/amd64/libglass.so" \
           "${JAVA_HOME}/jre/lib/amd64/libgstreamer-lite.so" \
           "${JAVA_HOME}/jre/lib/amd64/"libjavafx*.so \
           "${JAVA_HOME}/jre/lib/amd64/"libjfx*.so && \
    rm -rf "${JAVA_HOME}/jre/bin/jjs" \
           "${JAVA_HOME}/jre/bin/keytool" \
           "${JAVA_HOME}/jre/bin/orbd" \
           "${JAVA_HOME}/jre/bin/pack200" \
           "${JAVA_HOME}/jre/bin/policytool" \
           "${JAVA_HOME}/jre/bin/rmid" \
           "${JAVA_HOME}/jre/bin/rmiregistry" \
           "${JAVA_HOME}/jre/bin/servertool" \
           "${JAVA_HOME}/jre/bin/tnameserv" \
           "${JAVA_HOME}/jre/bin/unpack200" \
           "${JAVA_HOME}/jre/lib/ext/nashorn.jar" \
           "${JAVA_HOME}/jre/lib/jfr.jar" \
           "${JAVA_HOME}/jre/lib/jfr" \
           "${JAVA_HOME}/jre/lib/oblique-fonts" && \
    wget --progress=bar:force --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" -O /tmp/jce_policy-8.zip && \
    unzip -jo -d "${JAVA_HOME}/jre/lib/security" "/tmp/jce_policy-8.zip" && \
    apk del build-dependencies && \
    rm /tmp/* && chown -R ${USERNAME}:${GROUPNAME} /usr/lib/jvm
    

ENV PATH=$PATH:${JAVA_HOME}/bin \
    LANG=C.UTF-8

##############################
### INSTALL JENKINS 2.46.2 ###
##############################
COPY jenkins.sh install-plugins.sh plugins.txt plugin_loop.sh jenkins-support /usr/local/bin/
RUN curl -fsSL https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.46.2/jenkins-war-2.46.2.war -o /usr/share/jenkins/jenkins.war && \
    chown -R ${USERNAME}:${GROUPNAME} ${JENKINS_HOME} /usr/share/jenkins /usr/local/bin/install-plugins.sh /usr/local/bin/jenkins-support /usr/local/bin/jenkins.sh /usr/local/bin/plugin_loop.sh

EXPOSE 22 8080 50000
VOLUME /var/lib/jenkins
USER ${USERNAME} 
#RUN cd /usr/local/bin && ./plugin_loop.sh plugins.txt
CMD ["/usr/local/bin/jenkins.sh"]
