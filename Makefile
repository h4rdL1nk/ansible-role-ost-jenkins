APP                = ansible-role-smd-mongodb
APP_DESCRIPTION    = Ansible role
APP_COMPANY        = Telefonica I+D
APP_MAINTAINER     = Fernando Gonzalez <fernando.gonzalezlara.ext@telefonica.com>
APP_YEAR           = 2017
ROOT               = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REQ                = requirements.txt
REQ_DOCS           = requirements_docs.txt
VIRTUALENV         ?= $(shell which virtualenv)
PYTHON             ?= $(shell which python2.7)
PIP                ?= $(shell which pip2.7)
MOLECULE_PROVIDER  = virtualbox
VENV               ?= $(ROOT)/.venv
PLATFORMS          = rhel7
SHELL              = /bin/bash

.ONESHELL:
.PHONY: test test_rhel6 test_rhel7 clean venv docs venv_docs $(VENV)

all: default

default:
	@echo
	@echo "Welcome to '$(APP)' software package:"
	@echo
	@echo "usage: make <command>"
	@echo
	@echo "commands:"
	@echo "    clean                           - Remove generated files and directories"
	@echo "    venv                            - Create and update virtual environments"
	@echo "    destroy                         - Destroy molecule testing instance"
	@echo "    create                          - Create molecule testing instance"
	@echo "    dependency			   - Download role dependencies"
	@echo "    converge                        - Run molecule converge"
	@echo "    syntax                          - Run molecule syntax"
	@echo "    idempotence                     - Run molecule idempotence"
	@echo "    lint                            - Run yamlint validations"
	@echo

venv: $(VENV)

$(VENV): $(REQ)
	@echo ">>> Initializing virtualenv..."
	mkdir -p $@; \
	[ -z "$$VIRTUAL_ENV" ] && $(VIRTUALENV)  --no-site-packages  --distribute -p $(PYTHON) $@; \
	$@/bin/pip install --exists-action w -r $(REQ);

linkrole:
	@mkdir -p roles/ ; rm -rf roles/$(APP) 2>/dev/null;     ln -sf ../ roles/$(APP)

lint: venv
	@echo ">>> Executing yaml lint ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule lint;


destroy: venv
	@echo ">>> Deleting $(PLAFORM) ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule destroy;

verify: venv 
	@echo ">>> Runing $(PLAFORM) tests ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	PYTEST_ADDOPTS="--junit-xml junit-$(PLATFORM).xml --ignore roles/$(APP)" molecule verify;

create: venv
	@echo ">>> Runing $(PLAFORM) create ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule create;

dependency: venv
	@echo ">>> Download dependencies $(PLAFORM) ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule dependency;

converge: venv
	@echo ">>> Runing $(PLAFORM) converge ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule converge;

syntax: venv linkrole delete
	@echo ">>> Runing $(PLAFORM) syntax check ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule syntax;

idempotence:
	@echo ">>> Runing $(PLAFORM) idempotence ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule idempotence;

docs: venv_docs
	@echo ">>> Generating documentation ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	cd docs && make clean && SPHINXPROJ="$(APP)" APP="$(APP)" VERSION="$(VERSION)" DESCRIPTION="$(APP_DESCRIPTION)" MAINTAINER="$(APP_MAINTAINER)" COMPANY="$(APP_COMPANY)" YEAR="$(APP_YEAR)" make rst; \
	pandoc --from=rst --to=markdown --output=../README.md _build/rst/index.rst

venv_docs: $(REQ_DOCS)
	@echo ">>> Initializing virtualenv..."
	mkdir -p $(VENV); \
	[ -z "$$VIRTUAL_ENV" ] && $(VIRTUALENV)  --no-site-packages  --distribute -p $(PYTHON) $(VENV); \
	source $(VENV)/bin/activate; $(VENV)/bin/pip install --exists-action w -U -r $(REQ_DOCS);

clean:
	@echo ">>> Cleaning temporal files..."
	rm -rf .cache/
	rm -rf $(VENV)
	rm -rf junit-*.xml
	rm -rf tests/__pycache__/
	rm -rf .vagrant/
	rm -rf .molecule/
	@echo

