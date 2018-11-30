.PHONY: dev prod cleandev cleanprod compile release publish docs test run

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
APP_NAME := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
LOG_PREFIX = '${APP_NAME} | ${MIX_ENV}:'

dev: export MIX_ENV = dev
dev: compile

prod: export MIX_ENV = prod
prod: git-status-test cleanprod compile

compile:
	@echo ${LOG_PREFIX} getting deps
	@mix deps.get 1>/dev/null
	@echo ${LOG_PREFIX} compiling deps
	@mix deps.compile 1>/dev/null
	@echo ${LOG_PREFIX} compiling application
	@mix compile 

cleandev: export MIX_ENV = dev
cleandev:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/dev deps

cleanprod: export MIX_ENV = prod
cleanprod:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/prod deps

release: export MIX_ENV = prod
release: prod
	@echo ${LOG_PREFIX} creating release
	@mix release --env=prod

publish: test docs prod
	@mix hex.publih

docs: git-status-test
	@echo ${LOG_PREFIX} updating documentation
	@mix docs
	@echo ${LOG_PREFIX} committing changes
	@git add --all
	@git commit -m "updated documentation"

run:
	iex -S mix

test:
	@echo ${LOG_PREFIX} running tests
	@mix test

git-status-test:
	@test -z "$(shell git status -s 2>&1)" \
          && echo "Git repo is clean" \
          || (echo "Failed: uncommitted changes in git repo" && exit 1)

