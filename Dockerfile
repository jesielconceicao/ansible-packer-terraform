FROM ubuntu:bionic-20200219

ARG TERRAFORM_VERSION="0.14.7"
ARG ANSIBLE_VERSION="2.9.6"
ARG PACKER_VERSION="1.7.0"
ARG AWSCLI_VERSION="2.1.29"
ARG TERRAFORM_PROVISIONER_ANSIBLE_VERSION="2.5.0"

LABEL maintainer="Jesiel <jesielconceicao@gmail.com>"
LABEL terraform_version=${TERRAFORM_VERSION}
LABEL ansible_version=${ANSIBLE_VERSION}
LABEL aws_cli_version=${AWSCLI_VERSION}
LABEL terraform-provisioner-ansible_verison=${TERRAFORM_PROVISIONER_ANSIBLE_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ENV AWSCLI_VERSION=${AWSCLI_VERSION}
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV PACKER_VERSION=${PACKER_VERSION}

RUN apt-get update \
    && apt-get install -y ansible curl unzip make openssh-client 

RUN curl -LO https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip \
    && unzip '*.zip' \
    && rm *.zip \
    && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm -R aws   

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -LO https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip '*.zip' -d /usr/local/bin \
    && rm *.zip

RUN curl -LO https://github.com/radekg/terraform-provisioner-ansible/releases/download/v${TERRAFORM_PROVISIONER_ANSIBLE_VERSION}/terraform-provisioner-ansible-linux-amd64_v${TERRAFORM_PROVISIONER_ANSIBLE_VERSION} \
    && mkdir -p ~/.terraform.d/plugins/ \
    && mv terraform-provisioner-ansible-linux-amd64_v${TERRAFORM_PROVISIONER_ANSIBLE_VERSION} ~/.terraform.d/plugins/terraform-provisioner-ansible_v${TERRAFORM_PROVISIONER_ANSIBLE_VERSION} \
    && chmod +x ~/.terraform.d/plugins/terraform-provisioner-ansible_v${TERRAFORM_PROVISIONER_ANSIBLE_VERSION}

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /data

CMD    ["/bin/bash"]