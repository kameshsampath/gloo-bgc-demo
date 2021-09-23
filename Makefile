SHELL := /usr/bin/env bash
ENV_FILE := .envrc
include ${ENV_FILE}
CURRENT_DIR = $(shell pwd)

.PHONY:	clean	lint	edit-vars	rekey-vars	run

clean:
	
lint:	
	@ansible-lint --force-color

.local.vars.yml:	
	cp vars.yml.example .local.vars.yml

encrypt-vars:	.local.vars.yml
	ansible-vault encrypt --vault-password-file=$(VAULT_FILE) .local.vars.yml

edit-vars:
	ansible-vault edit --vault-password-file=$(VAULT_FILE) .local.vars.yml

view-vars:
	ansible-vault view --vault-password-file=$(VAULT_FILE) .local.vars.yml

cloud-run:
	@poetry shell
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,cloud" playbook.yml 

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
	@vagrant up

vm-destroy:
	@vagrant destroy --force