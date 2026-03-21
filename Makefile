REPO_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SRC_DIR  := $(REPO_DIR)/src

.PHONY: help install sync
.DEFAULT_GOAL := help

## help: Show this help message
help:
	@echo "Usage: make <target>"
	@echo ""
	@grep -E '^## [a-zA-Z_-]+:' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":"}; {printf "  %-12s %s\n", substr($$1, 4), $$2}'

## install: Symlink dotfiles into HOME (safe to re-run)
install:
	@echo "==> Symlinking dotfiles to $(HOME)"
	@for f in $$(find "$(SRC_DIR)" -maxdepth 1 -type f); do \
		target="$(HOME)/.$$(basename $$f)"; \
		ln -sfv "$$f" "$$target"; \
	done
	@echo "==> Symlinking shellrc.d"
	@ln -sfnv "$(SRC_DIR)/shellrc.d" "$(HOME)/.shellrc.d"
	@echo "==> Symlinking claude/settings.json"
	@mkdir -p "$(HOME)/.claude"
	@ln -sfv "$(SRC_DIR)/claude/settings.json" "$(HOME)/.claude/settings.json"
	@echo ""
	@echo "Done. Open a new shell or run: source ~/.zshrc"

## sync: Pull latest changes from remote (rebase)
sync:
	@git -C "$(REPO_DIR)" pull --rebase
