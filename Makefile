#!make
.PHONY: clean-pyc clean-build
.DEFAULT_GOAL := help

SHELL = /bin/bash

help:
	@echo ""
	@echo " +---------------------------------------+"
	@echo " | Rasa NLU Backport                     |"
	@echo " +---------------------------------------+"
	@echo "    clean"
	@echo "        Remove python and build artifacts"
	@echo "    install"
	@echo "        Install requirements for development and testing"
	@echo "    demo"
	@echo "        Run a simple demo"
	@echo ""
	@echo "    test"
	@echo "        Run unit tests"
	@echo "    test-all"
	@echo "        Run integration tests"
	@echo ""

clean-pyc:
	@echo $@
	find . -name '*.pyc' -exec rm --force {} +
	find . -name '*.pyo' -exec rm --force {} +
	find . -name '*~'    -exec rm --force {} +
	find . -name '.coverage*' -exec rm --force {} +

clean-build:
	@echo $@
	rm --force --recursive .tox/
	rm --force --recursive build/
	rm --force --recursive dist/
	rm --force --recursive *.egg-info
	rm --force --recursive .pytest_cache/

clean-pycache:
	@echo $@
	find . -name '__pycache__' -exec rm -rf {} +

clean: clean-build clean-pyc clean-pycache

install: clean
	@echo $@
	pip install --no-cache-dir -U pip
	pip install --no-cache-dir -U -r requirements.txt
	# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	# python get-pip.py --force-reinstall
	python -m spacy download en
	# rm -f get-pip.py

demo: clean
	@echo $@
	python demo.py

flake: clean
	@echo $@
	flake8 --statistics --ignore E252 W504 rasa_nlu tests setup.py

bandit: clean
	@echo $@
	bandit -r rasa_nlu/ tests/ setup.py

test-unit: clean flake bandit
	@echo $@
	time python -m pytest -v -x tests/ --cov=rasa_nlu
	https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.0.0/en_core_web_sm-2.0.0.tar.gz

test-tox: clean
	@echo $@
	tox -vv

test: test-unit
	@echo $@

test-all: test-unit test-tox
	@echo $@

pypi-deps:
	@echo $@
	pip install -U twine

pypi-build: clean test-all pypi-deps
	@echo $@
	python setup.py sdist bdist_wheel
	twine check dist/*

pypi-upload-test: pypi-deps
	@echo $@
	python -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*

pypi-upload: pypi-deps
	@echo $@
	python -m twine upload dist/*
