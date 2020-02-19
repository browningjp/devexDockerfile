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
WORKDIR /devex

RUN git clone https://github.com/utherp0/workshop4

WORKDIR /devex/workshop4/documentationbasic
RUN mvn clean package -DfacilitatorName="$facilitatorName" -DfacilitatorEmail="$facilitatorEmail" -DfacilitatorTitle="$facilitatorTitle" -DwebConsoleUrl="$webConsoleUrl" -DterminalUrl="$terminalUrl"
RUN mkdir /var/www/html/basic
RUN cp -r ocp4devex/target/generated-docs/* /var/www/html/basic/
RUN mv /var/www/html/basic/ocp4devex.html /var/www/html/basic/index.html
RUN mv /var/www/html/basic/ocp4devex.pdf /var/www/html/basic/ocp4devex_basic.pdf

WORKDIR /devex/workshop4/documentationadvanced
RUN mvn clean package -DfacilitatorName="$facilitatorName" -DfacilitatorEmail="$facilitatorEmail" -DfacilitatorTitle="$facilitatorTitle" -DwebConsoleUrl="$webConsoleUrl" -DterminalUrl="$terminalUrl"
RUN mkdir /var/www/html/advanced
RUN cp -r ocp4devex/target/generated-docs/* /var/www/html/advanced/
RUN mv /var/www/html/advanced/ocp4devex.html /var/www/html/advanced/index.html
RUN mv /var/www/html/advanced/ocp4devex.pdf /var/www/html/advanced/ocp4devex_advanced.pdf