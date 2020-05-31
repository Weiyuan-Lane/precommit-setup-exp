
YELP_VERSION := v0.13.1
PRE_COMMIT_CONFIG_FILE := .pre-commit-config.yaml
BASELINE_FILE := .secrets.baseline

# Add to repository for the first time
install: _pipValidation _pipInstallPreCommit _addPreCommitConfig _addBaselineFile _installHooks
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
	@printf "{\
\n\t\"exclude\": {\
\n\t\t\"files\": null,\
\n\t\t\"lines\": null\
\n\t},\
\n\t\"generated_at\": \"2020-05-30T19:28:10Z\",\
\n\t\"plugins_used\": [\
\n\t\t{\
\n\t\t\t\"name\": \"AWSKeyDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"ArtifactoryDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"base64_limit\": 4.5,\
\n\t\t\t\"name\": \"Base64HighEntropyString\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"BasicAuthDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"hex_limit\": 3,\
\n\t\t\t\"name\": \"HexHighEntropyString\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"JwtTokenDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"keyword_exclude\": null,\
\n\t\t\t\"name\": \"KeywordDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"MailchimpDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"PrivateKeyDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"SlackDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"SoftlayerDetector\"\
\n\t\t},\
\n\t\t{\
\n\t\t\t\"name\": \"StripeDetector\"\
\n\t\t}\
\n\t],\
\n\t\"results\": {},\
\n\t\"version\": \"0.13.0\",\
\n\t\"word_list\": {\
\n\t\t\"file\": null,\
\n\t\t\"hash\": null\
\n\t}\
\n}\n\
" >$(BASELINE_FILE)
