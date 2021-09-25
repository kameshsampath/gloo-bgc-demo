SHELL := /usr/bin/env bash
ENV_FILE := .envrc
include ${ENV_FILE}
CURRENT_DIR = $(shell pwd)

.PHONY:	clean	lint	edit-vars	rekey-vars	run	encrypt-vars	view-vars	base-run	cloud-run	cloud-civo-run	cloud-gcp-run	cloud-aws-run	app-run	istio-run	istio-run	workload-run	vm-up	vm-destroy	test

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
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base" playbook.yml 

cloud-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,cloud" playbook.yml 

cloud-civo-run:
	@poetry shell
	ansible-playbook --tags "base,civo" --vault-password-file=$(VAULT_FILE) playbook.yml 

cloud-gcp-run:
	@poetry shell
	ansible-playbook --tags "base,gcp" --vault-password-file=$(VAULT_FILE) playbook.yml 
		
cloud-aws-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,aws" playbook.yml

app-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "workload,app" playbook.yml

istio-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "workload,istio" playbook.yml

workload-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,workload,app,istio" playbook.yml

vm-up:
	@poetry shell
	vagrant up

vm-destroy:
	vagrant destroy --force

test:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) test.yml
