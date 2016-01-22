# install.sh
```
$ git clone https://github.com/adeshmukh/dotfiles.git
$ cd dotfiles
$ ./install.sh # 0. Runs uninstall.sh
                  # a. Adds magic lines at the end of ~/.bashrc
                  # b. Removes all links in $HOME that point into this folder (this will ensure broken links are removed after step #3)
               # 1. ln to all top level files/folders in this repository
```
