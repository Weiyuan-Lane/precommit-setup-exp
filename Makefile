
YELP_VERSION := v0.13.1
PRE_COMMIT_CONFIG_FILE := .pre-commit-config.yaml
BASELINE_FILE := .secrets.baseline

# Add to repository for the first time
install: _pipValidation _pipInstallPreCommit _pipInstallDetectSecrets _addPreCommitConfig _addBaselineFile _installHooks
	@echo 'The setup is complete! Please commit the newly created files `.secrets.baseline` file'

# For all other developers, adding the developer pre-hook
addDetectSecrets: _pipValidation _pipInstallPreCommit _installHooks

# Remove from repository
uninstall: _pipValidation _pipInstallPreCommit
	@pre-commit uninstall
	@[ -e $(PRE_COMMIT_CONFIG_FILE) ] && rm $(PRE_COMMIT_CONFIG_FILE)
	@[ -e $(BASELINE_FILE) ] && rm $(BASELINE_FILE)

# All private steps will start with a "_"
_pipValidation:
	@which pip
	@if [ $$? -ne 0 ]; then \
		echo "ERROR: Please install pip first"; \
		exit 1; \
	fi;

_pipInstallPreCommit:
	@pip install pre-commit

_pipInstallDetectSecrets:
	@pip install detect-secrets

_installHooks:
	@pre-commit install

_addPreCommitConfig:
	@printf "\n\
- repo: git@github.com:Yelp/detect-secrets\n\
  rev: $(YELP_VERSION)\n\
  hooks:\n\
  - id: detect-secrets\n\
    args: ['--baseline', '.secrets.baseline']\n\
    exclude: .*/tests/.*\n\
" >$(PRE_COMMIT_CONFIG_FILE)

_addBaselineFile:
	@detect-secrets scan > $(BASELINE_FILE)
