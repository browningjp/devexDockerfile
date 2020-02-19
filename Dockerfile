FROM registry.redhat.io/rhel8/httpd-24

ARG facilitatorName
ARG facilitatorEmail
ARG facilitatorTitle
ARG webConsoleUrl
ARG terminalUrl

USER root

RUN yum update -y && \
    yum install -y maven git && \
    yum clean all -y

RUN mkdir /devex
RUN mkdir /var/www/html/basic
WORKDIR /devex

RUN git clone https://github.com/utherp0/workshop4

WORKDIR /devex/workshop4/documentationbasic

RUN mvn clean package -DfacilitatorName="$facilitatorName" -DfacilitatorEmail="$facilitatorEmail" -DfacilitatorTitle="$facilitatorTitle" -DwebConsoleUrl="$webConsoleUrl" -DterminalUrl="$terminalUrl"

RUN cp -r ocp4devex/target/generated-docs/* /var/www/html/basic/
RUN mv /var/www/html/basic/ocp4devex.html /var/www/html/basic/index.html