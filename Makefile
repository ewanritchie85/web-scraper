PROJECT_NAME = nobel-prize-data
PYTHON_INTERPRETER = python
SHELL := /bin/bash
PROFILE = default
PIP := pip

# Define the PYTHONPATH
PYTHONPATH := $(shell pwd)

TEST_DIR := tests

# Define utility variable to help calling Python from the virtual environment
ACTIVATE_ENV := if [ -d "venv" ]; then source venv/bin/activate; else echo "Virtual environment not found! Run 'make create-environment'."; exit 1; fi

# Execute python related functionalities from within the project's environment
define execute_in_env
	$(ACTIVATE_ENV) && $1
endef

## Create python interpreter environment and install requirements.
dev-env:
	@echo ">>> About to create environment: $(PROJECT_NAME)..."
	@echo ">>> check python3 version"
	$(PYTHON_INTERPRETER) --version
	@echo ">>> Setting up VirtualEnv."
	$(PIP) install -q virtualenv virtualenvwrapper
	virtualenv venv --python=$(PYTHON_INTERPRETER)
	$(call execute_in_env, $(PIP) install pip-tools)
	$(call execute_in_env, pip-compile requirements.in)
	$(call execute_in_env, $(PIP) install -r ./requirements.txt)

################################################################################################################
# Dev Setup
## Install bandit
bandit:
	$(call execute_in_env, $(PYTHON_INTERPRETER) -m pip install bandit)

## Install safety
safety:
	$(call execute_in_env, $(PYTHON_INTERPRETER) -m pip install safety)

## Install black
black:
	$(call execute_in_env, $(PYTHON_INTERPRETER) -m pip install black)

## Install coverage
coverage:
	$(call execute_in_env, $(PYTHON_INTERPRETER) -m pip install coverage)

## Set up dev requirements (bandit, safety, black, coverage)
dev-setup: bandit safety black coverage

################################################################################################################
# Build / Run

## Run the security test (bandit + safety)
security-test:
	$(call execute_in_env, $(PYTHON_INTERPRETER) -m safety check -r ./requirements.txt)
	$(call execute_in_env, $(PYTHON_INTERPRETER) -m bandit -lll src/*.py tests/*.py)

## Run the black code check
run-black:
	$(call execute_in_env, $(PYTHON_INTERPRETER) -m black ./src/*.py ./tests/*.py)

## Run the unit tests
unit-test:
	if [ ! -d "venv" ]; then echo "Virtual environment not found! Run 'make create-environment'."; exit 1; fi
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} $(PYTHON_INTERPRETER) -m pytest)

## Run the coverage check
check-coverage:
	if [ ! -d "venv" ]; then echo "Virtual environment not found! Run 'make create-environment'."; exit 1; fi
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} $(PYTHON_INTERPRETER) -m pytest --cov=src tests/)

## Run all checks
run-checks: security-test run-black check-coverage

################################################################################################################
# Cleanup

## Clean up environmentm
clean:
	rm -rf venv .pytest_cache .coverage
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
	find . -type f -name '*.txt' -delete
	find . -type f -name '*.zip' -delete

################################################################################################################
# Docs

## Make docs
pdocs:
	$(call execute_in_env. export PYTHONPATH=src && $(PYTHON_INTERPRETER) -m pdoc -o docs src/*.py)