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
	rm --force --recursive demo_models/
	rm --force --recursive logs/

clean-pycache:
	@echo $@
	find . -name '__pycache__' -exec rm -rf {} +

clean: clean-build clean-pyc clean-pycache

install: clean
	@echo $@
	pip install --no-cache-dir -U pip
	pip install --no-cache-dir -U -r requirements.txt
	python -m spacy download en

demo: clean
	@echo $@
	python demo.py api

demo-http: clean
	@echo $@
	python demo.py http

flake: clean
	@echo $@
	# flake8 --statistics --ignore E252 --ignore W504 rasa_nlu tests setup.py
	flake8 --statistics --ignore E252 --ignore W504 demo.py setup.py

bandit: clean
	@echo $@
	#bandit -r rasa_nlu/ tests/ setup.py
	bandit -r rasa_nlu/ demo.py setup.py

test-unit: clean flake bandit
	@echo $@
	time python -m pytest -v -x tests/ --cov=rasa_nlu

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

pypi-version:
	rm -f ENV
	@echo "VERSION=$(shell python -c 'import rasa_nlu;print(rasa_nlu.__version__)')" > ENV
	# sed -i "s/^VERSION=.*/VERSION=$(shell python -c 'import rasa_nlu;print(rasa_nlu.__version__)')/" ENV

docker-push: clean pypi-version
	@echo $@
	docker-compose --env-file ENV push

docker-build: clean pypi-version
	@echo $@
	DOCKER_BUILDKIT=1 COMPOSE_DOCKER_CLI_BUILD=1 docker-compose --env-file ENV build --force-rm --no-cache --pull --progress=auto

docker-build-dev: clean pypi-version
	@echo $@
	DOCKER_BUILDKIT=0 COMPOSE_DOCKER_CLI_BUILD=0 docker-compose --env-file ENV build --progress=auto	

docker-up: demo pypi-version
	@echo $@
	rm -rf rasa-nlu-contrib-app-data/projects
	mkdir -p rasa-nlu-contrib-app-data/data
	mkdir -p rasa-nlu-contrib-app-data/logs
	mkdir -p rasa-nlu-contrib-app-data/projects
	mv demo_models/* rasa-nlu-contrib-app-data/projects
	ls rasa-nlu-contrib-app-data/projects
	docker-compose --env-file ENV up
