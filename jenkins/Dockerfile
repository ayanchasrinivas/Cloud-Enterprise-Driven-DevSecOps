FROM jenkins/jenkins:lts-jdk17

USER root

ENV DC_VERSION=12.1.8

# Install prerequisites
RUN apt-get update && \
    apt-get install -y \
        wget \
        curl \
        unzip \
        git \
        maven \
        docker.io \
        gnupg \
        lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Dependency Check
RUN wget https://github.com/dependency-check/DependencyCheck/releases/download/v${DC_VERSION}/dependency-check-${DC_VERSION}-release.zip && \
    unzip dependency-check-${DC_VERSION}-release.zip -d /opt && \
    rm dependency-check-${DC_VERSION}-release.zip && \
    ln -s /opt/dependency-check/bin/dependency-check.sh /usr/local/bin/dependency-check

# Install Trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
    gpg --dearmor -o /usr/share/keyrings/trivy.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/trivy.list && \
    apt-get update && \
    apt-get install -y trivy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jenkins