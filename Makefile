dev: ## start debugging 
	@echo "// todo: implement"

tests: ## start testing 
	@echo "// todo: implement"

release-pipeline: install-dependencies build-bundle ## command pipelines runs to create new release

install-dependencies: ## install all needed dependencies before run
	(cd src/ ; flutter pub get)

build-deb: ## build as a deb file
	@bash devops/scripts/build/build-deb.sh

build-bundle: ## build as a bundle
	@bash devops/scripts/build/build-bundle.sh

help: ## print our all commands to commandline
	@echo "\033[34m"
	@echo "		Linux Incoice Creator"
	@echo "	   ------------------------------------"
	@echo "     github: https://github.com/Jean28518/invoice-creator-german"
	@echo "\033[0m"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'