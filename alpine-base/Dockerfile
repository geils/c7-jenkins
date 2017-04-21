### ALPINE LINUX BASED JENKINS INCLUDE ORACLE JDK8
FROM alpine:3.5
MAINTAINER Github:dostroke <isgenez@gmail.com>

ENV JDK_VER=8u121 \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle

##########################
### DOWNLOAD JDK 8u121 ###
##########################
RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates unzip && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz" -O /tmp/jdk-${JDK_VER}-linux-x64.tar.gz && \
    tar -xvf /tmp/jdk-8u121-linux-x64.tar.gz -C /tmp && \
    mv /tmp/jdk1.8.0_121 ${JAVA_HOME} && \
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
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" && \
    unzip -jo -d "${JAVA_HOME}/jre/lib/security" "jce_policy-8.zip" && \
    apk del build-dependencies && \
    rm /tmp/*


