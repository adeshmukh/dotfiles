REPO_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SRC_DIR  := $(REPO_DIR)/src

.PHONY: help install bootstrap packages repos sync claude-skills
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
	@echo "==> Symlinking claude/"
	@mkdir -p "$(HOME)/.claude"
	@ln -sfv "$(SRC_DIR)/claude/settings.json" "$(HOME)/.claude/settings.json"
	@ln -sfv "$(SRC_DIR)/claude/statusline-command.sh" "$(HOME)/.claude/statusline-command.sh"
	@chmod +x "$(SRC_DIR)/claude/statusline-command.sh"
	@ln -sfv "$(SRC_DIR)/claude/CLAUDE.md" "$(HOME)/.claude/CLAUDE.md"
	@ln -sfv "$(SRC_DIR)/claude/marketplace.json" "$(HOME)/.claude/marketplace.json"
	@echo ""
	@echo "Done. Open a new shell or run: source ~/.zshrc"
	@echo "Tip: on a new machine, run: make bootstrap && make packages && make repos"

## bootstrap: Install the platform package manager tool (prerequisite for packages)
bootstrap:
	@"$(REPO_DIR)/packages/bootstrap"

## packages: Install system packages for the current platform
packages: bootstrap
	@case "$$(uname -s)" in \
	  Darwin) echo "==> Installing Homebrew packages" && brew bundle --file="$(REPO_DIR)/packages/Brewfile" ;; \
	  Linux)  \
	    if [ -f /etc/debian_version ]; then \
	      echo "==> Installing apt packages via apt-bundle" && apt-bundle -f "$(REPO_DIR)/packages/Aptfile"; \
	    elif [ -f /etc/redhat-release ]; then \
	      echo "==> Installing yum packages" && xargs yum install -y < "$(REPO_DIR)/packages/Yumfile"; \
	    else \
	      echo "Unsupported Linux distro"; exit 1; \
	    fi ;; \
	  *) echo "Unsupported platform: $$(uname -s)"; exit 1 ;; \
	esac

## repos: Clone git-based tools and plugins declared in packages/Repofile
repos:
	@"$(REPO_DIR)/packages/repo-bundle" "$(REPO_DIR)/packages/Repofile"

## claude-skills: Print slash commands to register marketplace and install all skills
claude-skills:
	@echo "==> Run these slash commands inside Claude Code:"
	@echo ""
	@MARKETPLACE=$$(node -e "process.stdout.write(require('$(HOME)/.claude/marketplace.json').name)"); \
	 echo "  /plugin marketplace add $(HOME)/.claude/marketplace.json"; \
	 node -e " \
	   const m = require('$(HOME)/.claude/marketplace.json'); \
	   m.plugins.forEach(p => console.log('  /plugin install ' + p.name + '@' + m.name)); \
	 "
	@echo ""

## sync: Pull latest changes from remote (rebase)
sync:
	@git -C "$(REPO_DIR)" pull --rebase
