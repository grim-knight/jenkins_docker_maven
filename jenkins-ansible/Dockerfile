from jenkins/jenkins

USER root

RUN apt-get update && \
    apt-get install -y  python3 python3-pip && \
    pip3 install ansible --upgrade

USER jenkins
