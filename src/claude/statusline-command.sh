#!/usr/bin/env bash
# ~/.claude/statusline-command.sh
# Status line for Claude Code, styled after the user's zsh PS1.
# Receives JSON on stdin.

input=$(cat)

# Extract fields from JSON
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Git branch (skip optional locks, suppress errors)
git_branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
        || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# ANSI colors
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[0;37m'
RESET='\033[0m'

parts=""

# Git branch (yellow)
if [ -n "$git_branch" ]; then
    parts="${parts}$(printf "${YELLOW} %s ${RESET}" "$git_branch")"
fi

# Time (red)
parts="${parts}$(printf "${RED} %s ${RESET}" "$(date +%H:%M:%S)")"

# Hostname (blue)
parts="${parts}$(printf "${BLUE} %s ${RESET}" "$(hostname -s)")"

# CWD (white) — abbreviate $HOME as ~
if [ -n "$cwd" ]; then
    display_cwd="${cwd/#$HOME/\~}"
    parts="${parts}$(printf "${WHITE} %s ${RESET}" "$display_cwd")"
fi

# Model (white)
if [ -n "$model" ]; then
    parts="${parts}$(printf "${WHITE}[%s]${RESET}" "$model")"
fi

# Context usage
if [ -n "$used_pct" ]; then
    used_int=$(printf '%.0f' "$used_pct")
    parts="${parts}$(printf " ctx:%s%%" "$used_int")"
fi

printf "%b\n" "$parts"
