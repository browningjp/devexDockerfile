FROM fedora

ARG facilitatorName="Jonny Browning"
ARG facilitatorEmail="browning@redhat.com"
ARG facilitatorTitle="Junior Solution Architect"
ARG webConsoleUrl
ARG ocpUrl
ARG ocpToken

ENV MAVEN_OPTS=-Xmx2048m -XX:MaxPermSize=128m

USER root

RUN yum install -y maven ansible python-pip

RUN mkdir /devex
WORKDIR /devex

RUN curl -L https://github.com/utherp0/workshop4/tarball/master > master && tar -xvf master && mv utherp0-workshop4-* workshop4
RUN curl -L https://github.com/openshift/origin/releases/download/v1.5.1/openshift-origin-client-tools-v1.5.1-7b451fc-linux-64bit.tar.gz > oc.tar.gz && tar -xvf oc.tar.gz && mv openshift-origin-*/oc /bin/oc

RUN mkdir /devexcompiled
RUN chown -R 1001:1001 /devexcompiled

WORKDIR /devex/workshop4/documentationbasic
RUN mvn clean package -DfacilitatorName="$facilitatorName" -DfacilitatorEmail="$facilitatorEmail" -DfacilitatorTitle="$facilitatorTitle" -DwebConsoleUrl="$webConsoleUrl"
RUN mkdir -p /devexcompiled/basic
RUN cp -r ocp4devex/target/generated-docs/* /devexcompiled/basic
RUN mv /devexcompiled/basic/ocp4devex.html /devexcompiled/basic/index.html
RUN mv /devexcompiled/basic/ocp4devex.pdf /devexcompiled/ocp4devex_basic.pdf

WORKDIR /devex/workshop4/documentationadvanced
RUN mvn clean package -DfacilitatorName="$facilitatorName" -DfacilitatorEmail="$facilitatorEmail" -DfacilitatorTitle="$facilitatorTitle" -DwebConsoleUrl="$webConsoleUrl"
RUN mkdir -p /devexcompiled/advanced
RUN cp -r ocp4devex/target/generated-docs/* /devexcompiled/advanced
RUN mv /devexcompiled/advanced/ocp4devex.html /devexcompiled/advanced/index.html
RUN mv /devexcompiled/advanced/ocp4devex.pdf /devexcompiled/ocp4devex_advanced.pdf

RUN chown -R 1001:1001 /devexcompiled

RUN pip install kubernetes
RUN ansible-playbook -e "ocp_url=$ocpUrl ocp_login_token=$ocpToken" /devex/workshop4/playbooks/Deploy_Advanced_Course.yml

EXPOSE 8080

USER 1001

CMD python3 -m http.server 8080 --directory /devexcompiled