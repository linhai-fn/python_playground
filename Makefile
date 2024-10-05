
.SILENT: help
.PHONY: help fmt lint test

uv-run = uv run

help:
	echo "Available targets:"
	cat $(MAKEFILE_LIST) | \
	grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' | \
	awk 'BEGIN { FS = ":.*?## " } \
	{ cnt++; a[cnt] = $$1; b[cnt] = $$2; if (length($$1) > max) max = length($$1) } \
	END { for (i = 1; i <= cnt; i++) \
		printf "  $(shell tput setaf 6)%-*s$(shell tput setaf 0) %s\n", max, a[i], b[i] }'
	tput sgr0

fmt: ## Format code
	@echo "Formatting code..."
	$(uv-run) ruff check --select I --fix
	$(uv-run) ruff format
	@echo "Formatting Completed!"

lint: ## Lint code
	@echo "Linting code..."
	$(uv-run) ruff check
	$(uv-run) mypy .
	@echo "Linting Completed!"

test: ## Run tests
	$(uv-run) pytest
