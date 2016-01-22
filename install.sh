#!/bin/bash

INSTALL_PATH=${1:-~/.bashrc.d} # Path to install the auxiliary scripts.
BASH_FILE=.bashrc # The file that will get the hook scriptlet.

if [ -d "${INSTALL_PATH}" ]; then echo "Aborting installation since $INSTALL_PATH already exists." >&2; exit 1; fi

# Create INSTALL_PATH exists
echo "Installing auxiliary scripts in ${INSTALL_PATH}"
mkdir -p ${INSTALL_PATH}

echo 'if [ -z "$PS1" ]; then return; else for f in $(find ~/${INSTALL_PATH} -type f -name '"'"'*.bash'"'"'); do source $f; done # dotfiles-installer' >> $BASH_FILE

