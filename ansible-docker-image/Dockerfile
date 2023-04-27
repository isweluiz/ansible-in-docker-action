FROM python:3.10.10-alpine3.16
LABEL MAINTEINER="@isweluiz" 


# Copying Ansible requirements
# ----------------------------
COPY requirements/requirements.txt /opt/requirements.txt 
COPY requirements/requirements.yml /opt/requirements.yml 

# Installing some dependencies
# ----------------------------
RUN apk update && \
    apk add --no-cache \
        git \
        openssh-client \
        openssl \
        rsync \
        sshpass \
        which \
        gettext && \
    apk --update add --virtual \
        builddeps \
        libffi-dev \
        openssl-dev \
        build-base && \
    pip install --upgrade \
        pip \
        cffi && \
    pip install --use-pep517 -r /opt/requirements.txt && \
    ansible-galaxy install -r /opt/requirements.yml --force &&\
    apk del builddeps && \
    rm -rf /var/cache/apk/*

# Creating Ansible folder
# ----------------------------
RUN mkdir -p /etc/ansible \
    && echo 'localhost' > /etc/ansible/hosts \
    && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

COPY ansible.cfg /etc/ansible/ansible.cfg

RUN which python
RUN ansible --version
