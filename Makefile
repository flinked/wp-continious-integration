.PHONY: dev deploy dbdeploy import dbimport help update

path=~/public_html/siteName
ssh=serverIp
domain=http://siteName.domain.fr
localDomain=http://localhost:8888/siteName
themeName=flinked/
phpServer=/usr/local/bin/

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

import: ## Importe les fichiers distants
	rsync -av $(ssh):$(path) ./ \
		--exclude wp-config.php

deploy: ## Déploie une nouvelle version de l'application
	rsync -av ../ $(ssh):$(path) \
		--exclude Makefile \
		--exclude sh/Makefile \
		--exclude wp-config.php \
		--exclude .git \
		--exclude .idea \
		--exclude .htacess \
		--exclude wp-content/themes/$(themeName)builder

deployFront: ## Déploie une nouvelle version de l'application
	rsync -av ../wp-content/themes/$(themeName) $(ssh):$(path)wp-content/themes/$(themeName) \
		--exclude Makefile \
		--exclude sh/Makefile \
		--exclude wp-config.php \
		--exclude .git \
		--exclude .idea \
		--exclude wp-content/uploads \
		--exclude .htacess \
		--exclude wp-content/themes/$(themeName)builder \
		--exclude builder

dbdeploy: ## Envoie les données sur le serveur
	php wp-cli.phar db export --add-drop-table dump.sql
	rsync -av ./dump.sql $(ssh):$(path)
	ssh $(ssh) "cd $(path); $(phpServer)php wp-cli.phar db import dump.sql; $(phpServer)php wp-cli.phar search-replace '$(localDomain)' '$(domain)';"
	rm dump.sql

dbimport: ## Récupère les données depuis le serveur
	ssh $(ssh) "cd $(path); $(phpServer)php wp-cli.phar db export --add-drop-table dump.sql"
	rsync -av $(ssh):$(path)dump.sql ./
	rsync -av $(ssh):$(path)wp-content/uploads/ ../wp-content/uploads/
	ssh $(ssh) "rm $(path)dump.sql"
	sh import.sh

update:
	php wp-cli.phar core update
	php wp-cli.phar plugin update --all