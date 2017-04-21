FROM centos:7.3.1611
MAINTAINER Sangjin Kim <sangzkim@sk.com>

ENV JENKINS_VER=2.46.1 \
    JENKINS_HOME=/app/jenkins \
    JENKINS_UC=https://updates.jenkins-ci.org \
    JDK_VER=8u121 \
    GIT_VER=2.12.2

### CENTOS INITIAL SETTINGS
RUN yum install -y epel-release net-tools vim && \
    yum update -y

RUN echo 'alias ll="ls -alF"' | tee -a /etc/profile && \
    echo 'alias vi="vim"' | tee -a /etc/profile && \
    ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

### INSTALL JDK 8u121
RUN yum upgrade -y && \
    yum install wget -y && \
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${JDK_VER}-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-${JDK_VER}-linux-x64.rpm" -O /tmp/jdk-${JDK_VER}-linux-x64.rpm

RUN yum install -y /tmp/jdk-${JDK_VER}-linux-x64.rpm && \
    yum clean all && rm -rf /tmp/jdk-${JDK_VER}-linux-x64.rpm

RUN cp /etc/profile /etc/profile_bak && \
    echo 'export JAVA_HOME=/usr/java/jdk1.8.0_121' | tee -a /etc/profile && \
    echo 'export JRE_HOME=/usr/java/jdk1.8.0_121/jre' | tee -a /etc/profile && \
    source /etc/profile

### INSTALL GIT 2.12.2
RUN wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VER}.tar.gz -O /tmp/git-${GIT_VER}.tar.gz && \
    yum groupinstall -y "Development Tools" && \
    yum install -y gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel 
    
RUN tar -xvf /tmp/git-${GIT_VER}.tar.gz -C /tmp && \
    ls -alF /tmp && \
    cd /tmp/git-${GIT_VER} && \
    make configure && \
    ./configure --prefix=/usr/local && \
    make install

### INSTALL JENKINS 2.46.1
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo && \
    rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key && \
   yum install -y jenkins-2.46.1 initscripts 
COPY plugins/0411_plugins.tar.gz /tmp/
RUN mkdir -p /var/lib/jenkins/plugins && \
    tar -xvf /tmp/0411_plugins.tar.gz -C /var/lib/jenkins/plugins/ && \
    chown -R jenkins:jenkins /var/lib/jenkins/plugins

EXPOSE 8080 50000
CMD /sbin/init
