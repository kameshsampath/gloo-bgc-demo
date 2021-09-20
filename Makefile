SHELL := /usr/bin/env bash
ENV_FILE := .envrc
include ${ENV_FILE}
CURRENT_DIR = $(shell pwd)

.PHONY:	clean	lint	edit-vars	rekey-vars	run

clean:
	
lint:	
	@ansible-lint --force-color

edit-vars:
	@ansible-vault edit --vault-password-file=$(VAULT_FILE) vars.yml

view-vars:
	@ansible-vault view --vault-password-file=$(VAULT_FILE) vars.yml

run:
	@ansible-playbook --vault-password-file=$(VAULT_FILE) playbook.yml
