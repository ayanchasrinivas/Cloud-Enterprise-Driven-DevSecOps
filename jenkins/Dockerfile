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
        docker-compose \
        iptables \
        iproute2 \
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

# Add jenkins to sudoers (for dockerd startup)
RUN echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/dockerd" >> /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins
 
# Add jenkins user to docker group
RUN usermod -aG docker jenkins
 
# Create startup script with proper heredoc
RUN cat > /usr/local/bin/start-docker-daemon.sh << 'SCRIPT_EOF'
#!/bin/bash
set -e
 
echo "[*] Starting Docker daemon..."
 
# Check if Docker daemon is already running
if ! docker ps > /dev/null 2>&1; then
    echo "[*] Docker daemon not responding, starting..."
    sudo dockerd --storage-driver=overlay2 \
        --log-driver=json-file \
        --insecure-registry=localhost:5000 \
        --data-root=/var/lib/docker &
    
    DOCKER_PID=$!
    echo "[*] Docker daemon PID: $DOCKER_PID"
    
    # Wait for daemon to be ready
    echo "[*] Waiting for Docker daemon to be ready..."
    for i in {1..60}; do
        if docker ps > /dev/null 2>&1; then
            echo "[✓] Docker daemon is ready!"
            break
        fi
        echo "[*] Attempt $i/60... waiting"
        sleep 1
    done
    
    if ! docker ps > /dev/null 2>&1; then
        echo "[✗] Docker daemon failed to start"
        exit 1
    fi
else
    echo "[✓] Docker daemon already running"
fi
 
echo "[✓] Docker is operational"
docker ps
SCRIPT_EOF
 
RUN chmod +x /usr/local/bin/start-docker-daemon.sh
 
USER jenkins