IMAGE:= redwindmill/rpi-haproxy
TAG:= test
BASE:=  FROM arm64v8/haproxy:
RUN_NAME:= rpi-haproxy

include $(MAKEFILE_BUILDER)
#------------------------------------------------------------------------------#

.PHONY: up
up::
	@docker run -d --restart=always \
		--init \
		--log-opt max-size=128k \
		--log-opt tag="$(RUN_NAME)" \
		--name "$(RUN_NAME)" \
		--hostname "$(RUN_NAME)-cont" \
		--security-opt no-new-privileges \
		--net proxy \
		-p 80:80 \
		-p 443:443 \
		$(IMAGE)

#------------------------------------------------------------------------------#
CERT_TMP:=$(BUILD_ROOT_PATH)/haproxy/cert
CERT_CONF:=$(CURDIR)/sample.san.cnf

.PHONY: cert
cert:
	@mkdir -p $(CERT_TMP)
	@openssl req \
		-newkey rsa:4096 -nodes \
		-config $(CERT_CONF) \
		-keyout $(CERT_TMP)/cert.key \
		-out $(CERT_TMP)/cert.csr
	@openssl x509 \
		-req -days 36500 \
		-extfile $(CERT_CONF) \
		-extensions req_ext \
		-in $(CERT_TMP)/cert.csr \
		-signkey $(CERT_TMP)/cert.key \
		-out $(CERT_TMP)/cert.crt
	@cat $(CERT_TMP)/cert.crt $(CERT_TMP)/cert.key > $(CERT_TMP)/cert.crt.key.pem

.PHONY: cert-check
cert-check:
	@echo "sha1 of key modulus : $$(openssl rsa -noout -modulus -in $(CERT_TMP)/cert.key | openssl sha1 -c)"
	@echo "sha1 of csr modulus : $$(openssl req -noout -modulus -in $(CERT_TMP)/cert.csr | openssl sha1 -c)"
	@echo "sha1 of crt modulus : $$(openssl x509 -noout -modulus -in $(CERT_TMP)/cert.crt | openssl sha1 -c)"

.PHONY: cert-view-key
cert-view-key:
	@openssl rsa -noout -text -in $(CERT_TMP)/cert.key

.PHONY: cert-view-csr
cert-view-csr:
	@openssl req -noout -text -in $(CERT_TMP)/cert.csr

.PHONY: cert-view-crt
cert-view-crt:
	@openssl x509 -noout -text -in $(CERT_TMP)/cert.crt
