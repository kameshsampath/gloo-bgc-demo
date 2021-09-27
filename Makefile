SHELL := /usr/bin/env bash
ENV_FILE := .envrc
include ${ENV_FILE}
CURRENT_DIR = $(shell pwd)

.PHONY:	clean	lint	edit-vars	rekey-vars	run	encrypt-vars	view-vars	base-run	cloud-run	cloud-civo-run	cloud-gcp-run	cloud-aws-run	app-run	istio-run	istio-run	workload-run	vm-up	vm-destroy	test	cloud-clean

clean:
	
lint:	
	@ansible-lint --force-color

.local.vars.yml:	
	cp vars.yml.example .local.vars.yml

encrypt-vars:	.local.vars.yml	
	@poetry shell
	ansible-vault encrypt --vault-password-file=$(VAULT_FILE) .local.vars.yml

edit-vars:
	@poetry shell
	ansible-vault edit --vault-password-file=$(VAULT_FILE) .local.vars.yml

view-vars:
	@poetry shell
	ansible-vault view --vault-password-file=$(VAULT_FILE) .local.vars.yml

base-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base" playbook.yml  $(EXTRA_ARGS)

cloud-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,cloud" playbook.yml  $(EXTRA_ARGS)

cloud-clean:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) cloud_clean.yml  $(EXTRA_ARGS)

cloud-civo-run:
	@poetry shell
	ansible-playbook --tags "base,civo" --vault-password-file=$(VAULT_FILE) playbook.yml  $(EXTRA_ARGS)

cloud-gcp-run:
	@poetry shell
	ansible-playbook --tags "base,gcp" --vault-password-file=$(VAULT_FILE) playbook.yml  $(EXTRA_ARGS)
		
cloud-aws-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,aws" playbook.yml $(EXTRA_ARGS)

app-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "workload,app" playbook.yml $(EXTRA_ARGS)

istio-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "workload,istio" playbook.yml $(EXTRA_ARGS)

workload-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,workload,app,istio" playbook.yml $(EXTRA_ARGS)

vm-up:
	@poetry shell
	vagrant up

vm-destroy:
	vagrant destroy --force

test:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) test.yml  $(EXTRA_ARGS)
