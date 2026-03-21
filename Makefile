REPO_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SRC_DIR  := $(REPO_DIR)/src

PLUGINS_DIR := $(HOME)/.local/share/zsh/plugins

.PHONY: help install packages plugins sync
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
	@echo ""
	@echo "Done. Open a new shell or run: source ~/.zshrc"
	@echo "Tip: to install system packages for this platform, run: make packages"

## packages: Install system packages for the current platform
packages:
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

## plugins: Clone zsh plugins to ~/.local/share/zsh/plugins (fallback if not via packages)
plugins:
	@mkdir -p "$(PLUGINS_DIR)"
	@for plugin in \
	    "zsh-users/zsh-autosuggestions" \
	    "zsh-users/zsh-syntax-highlighting"; do \
	  name=$$(basename $$plugin); \
	  if [ ! -d "$(PLUGINS_DIR)/$$name" ]; then \
	    echo "==> Cloning $$plugin"; \
	    git clone --depth=1 "https://github.com/$$plugin" "$(PLUGINS_DIR)/$$name"; \
	  else \
	    echo "==> $$name already present, skipping"; \
	  fi; \
	done

## sync: Pull latest changes from remote (rebase)
sync:
	@git -C "$(REPO_DIR)" pull --rebase
