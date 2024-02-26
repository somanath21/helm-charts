default: test
include examples.mk
RELEASE := helm-es-security
ELASTICSEARCH_IMAGE := docker.elastic.co/elasticsearch/elasticsearch:$(STACK_VERSION)
TIMEOUT := 1200s
install:
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml $(RELEASE) ../../
test: secrets install goss
purge:
	kubectl delete secrets elastic-credentials elastic-certificates elastic-certificate-pem elastic-certificate-crt|| true
	helm del $(RELEASE)
pull-elasticsearch-image:
	docker pull $(ELASTICSEARCH_IMAGE)
setup:
	#!/bin/bash \
	apt-get update \
	apt install sudo \
	sudo apt-get --assume-yes install apt-transport-https ca-certificates curl gnupg lsb-release \
	apt-get install -y apt-transport-https ca-certificates curl gpg \
	curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
	echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
	apt-get install -y kubelet kubeadm kubectl \
	apt-mark hold kubelet kubeadm kubectl \
	sudo apt-get install -y kubectl \
	curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
	chmod +x ./kubectl \
	sudo mv ./kubectl /usr/local/bin/kubectl \
	kubectl version \
	apt-get install sysvinit-utils \
	sudo apt-get --assume-yes install docker-ce docker-ce-cli containerd.io \
	whoami \
	service docker start \
	sleep 2s \
	service docker status \
	echo -----------------docker status---------------------

secrets:
	docker rm -f elastic-helm-charts-certs || true
	rm -f elastic-certificates.p12 elastic-certificate.pem elastic-certificate.crt elastic-stack-ca.p12 || true
	password=$$([ ! -z "$$ELASTIC_PASSWORD" ] && echo $$ELASTIC_PASSWORD || echo $$(docker run --rm busybox:1.31.1 /bin/sh -c "< /dev/urandom tr -cd '[:alnum:]' | head -c20")) && \
	docker run --name elastic-helm-charts-certs -i -w /app \
		$(ELASTICSEARCH_IMAGE) \
		/bin/sh -c " \
			elasticsearch-certutil ca --out /app/elastic-stack-ca.p12 --pass '' && \
			elasticsearch-certutil cert --name security-master --dns security-master --ca /app/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /app/elastic-certificates.p12" && \
	docker cp elastic-helm-charts-certs:/app/elastic-certificates.p12 ./ && \
	docker rm -f elastic-helm-charts-certs && \
	openssl pkcs12 -nodes -passin pass:'' -in elastic-certificates.p12 -out elastic-certificate.pem && \
	openssl x509 -outform der -in elastic-certificate.pem -out elastic-certificate.crt && \
	kubectl create namespace $(NAMESPACE) || echo "namespace already exists"  && \
	kubectl create secret generic elastic-certificates --namespace=$(NAMESPACE) --from-file=elastic-certificates.p12 && \
	kubectl create secret generic elastic-certificate-pem --namespace=$(NAMESPACE) --from-file=elastic-certificate.pem && \
	kubectl create secret generic elastic-certificate-crt --namespace=$(NAMESPACE)  --from-file=elastic-certificate.crt && \
	kubectl create secret generic elastic-credentials --namespace=$(NAMESPACE) --from-literal=password=$$password --from-literal=username=elastic && \
	rm -f elastic-certificates.p12 elastic-certificate.pem elastic-certificate.crt elastic-stack-ca.p12	