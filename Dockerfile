# Use a minimal base image to reduce the image size
FROM ubuntu:20.04

# Set environment variables
ENV M2_HOME=/opt/apache-maven-3.8.5
ENV PATH=$M2_HOME/bin:$PATH

# Install required packages and clean up
RUN apt-get update && \
    apt-get install -y \
    git \
    openjdk-17-jdk \
    curl \
    wget \
    lsb-release \
    software-properties-common \
    docker.io \
    python3-pip && \
    pip3 install awscli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Maven
RUN wget -q https://mirrors.estointernet.in/apache/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz -O /tmp/apache-maven-3.8.5-bin.tar.gz && \
    tar -xf /tmp/apache-maven-3.8.5-bin.tar.gz -C /opt/ && \
    rm /tmp/apache-maven-3.8.5-bin.tar.gz

# Install Trivy
RUN wget -qO /tmp/trivy-pubkey.gpg https://aquasecurity.github.io/trivy-repo/deb/public.key && \
    apt-key add /tmp/trivy-pubkey.gpg && \
    echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/trivy.list && \
    apt-get update && \
    apt-get install -y trivy && \
    rm /tmp/trivy-pubkey.gpg

# Install Hadolint
RUN curl -Lo /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.6.0/hadolint-Linux-x86_64 && \
    chmod +x /usr/local/bin/hadolint

# Set the working directory
WORKDIR /app
