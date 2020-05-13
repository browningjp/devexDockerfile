FROM fedora

ARG facilitatorName
ARG facilitatorEmail
ARG facilitatorTitle
ARG webConsoleUrl

USER root

RUN yum install -y maven

RUN mkdir /devex
WORKDIR /devex
# RUN git clone https://github.com/utherp0/workshop4

RUN wget https://github.com/utherp0/workshop4/tarball/master && tar -xvf master && mv utherp0-workshop4-* workshop4

RUN mkdir /devexcompiled
RUN chown -R 1001:1001 /devexcompiled

# WORKDIR /devex/workshop4/documentationbasic
# RUN mvn clean package -DfacilitatorName="$facilitatorName" -DfacilitatorEmail="$facilitatorEmail" -DfacilitatorTitle="$facilitatorTitle" -DwebConsoleUrl="$webConsoleUrl"
# RUN mkdir -p /devexcompiled/basic
# RUN cp -r ocp4devex/target/generated-docs/* /devexcompiled/basic
# RUN mv /devexcompiled/basic/ocp4devex.html /devexcompiled/basic/index.html
# RUN mv /devexcompiled/basic/ocp4devex.pdf /devexcompiled/ocp4devex_basic.pdf

WORKDIR /devex/workshop4/documentationadvanced
RUN mvn clean package -DfacilitatorName="$facilitatorName" -DfacilitatorEmail="$facilitatorEmail" -DfacilitatorTitle="$facilitatorTitle" -DwebConsoleUrl="$webConsoleUrl"
RUN mkdir -p /devexcompiled/advanced
RUN cp -r ocp4devex/target/generated-docs/* /devexcompiled/advanced
RUN mv /devexcompiled/advanced/ocp4devex.html /devexcompiled/advanced/index.html
RUN mv /devexcompiled/advanced/ocp4devex.pdf /devexcompiled/ocp4devex_advanced.pdf

RUN chown -R 1001:1001 /devexcompiled

EXPOSE 8080

USER 1001

CMD python3 -m http.server 8080 --directory /devexcompiled