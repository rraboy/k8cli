FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y git curl vim wget mosquitto-clients jq file

RUN curl -fSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && curl -fSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.139.9/helmfile_linux_amd64 \
    && chmod +x /usr/local/bin/helmfile \
    ; helm version \
    ; helmfile version

RUN curl -fSL -o /tmp/k9s.tgz 'https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz' \
    && tar -C /tmp/ -zxvf /tmp/k9s.tgz \
    && chmod +x /tmp/k9s \
    && mv /tmp/k9s /usr/local/bin/ \
    ; k9s version

RUN kversion=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
    && echo "kube stable version: $kversion" \
    && curl -fSL -o /tmp/kubectl "https://dl.k8s.io/release/${kversion}/bin/linux/amd64/kubectl" \
    && file /tmp/kubectl \
    && chmod +x /tmp/kubectl \
    && cp /tmp/kubectl /usr/local/bin/ \
    ; (kubectl version | true)

RUN adduser --disabled-password user 
USER user
WORKDIR /home/user

RUN helm plugin install https://github.com/databus23/helm-diff \
    && helm plugin install https://github.com/jkroepke/helm-secrets \
    && helm plugin list