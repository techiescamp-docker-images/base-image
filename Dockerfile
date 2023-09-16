FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV MAVEN_HOME /usr/share/maven
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

RUN apt-get update && \
    apt-get install -y git openjdk-17-jdk maven apt-transport-https ca-certificates curl wget gnupg lsb-release software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get install -y docker-ce

RUN wget -qO /tmp/trivy-pubkey.gpg https://aquasecurity.github.io/trivy-repo/deb/public.key && \
    apt-key add /tmp/trivy-pubkey.gpg && \
    echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/trivy.list && \
    apt-get update && \
    apt-get install -y trivy

RUN curl -Lo /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.6.0/hadolint-Linux-x86_64 && \
    chmod +x /usr/local/bin/hadolint

RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip3 install awscli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]
