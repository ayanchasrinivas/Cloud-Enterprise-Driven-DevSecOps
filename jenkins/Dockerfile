FROM jenkins/jenkins:lts-jdk17

USER root
RUN apt-get update && apt-get install -y \
    maven \
    git \
    docker.io \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && \
    apt-get install -y wget gnupg lsb-release && \
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/trivy.list && \
    apt-get update && \
    apt-get install -y trivy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jenkins
# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt