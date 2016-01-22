if [ -z "$PS1" ]; then return; else for f in $(find ~/${INSTALL_PATH} -type f -name '*.bash'); do source $f; done # dotfiles-installer
