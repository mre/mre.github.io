SHELL := /bin/bash

.PHONY: help
help: ## This help message
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

.PHONY: content
content: ## Build the content of the static site with zola
	zola build

.PHONY: index
index: content ## Build the search index with tinysearch
	tinysearch --optimize --path static public/json/index.html

.PHONY: minify
minify: ## Compress JavaScript assets
	terser --compress --mangle --output static/search_min.js -- static/search.mjs static/tinysearch_engine.js

.PHONY: build 
build: content index minify ## Build static site and search index, minify JS

.PHONY: run serve
run serve: ## Serve website locally
	zola serve