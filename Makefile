BASHRC_D=$(HOME)/.bashrc.d
BASHFILE=$(HOME)/.bashrc

.PHONY: .hooks list

.makedir:
	mkdir -p $(BASHRC_D)

.link:
	ln -Fis $(PWD)/src/bashrc.d $(BASHRC_D)

.copy:
	cp -rf $(PWD)/src/bashrc.d/* $(BASHRC_D)

.hooks:
	echo 'if [ -z "$$PS1" ]; then return; else for f in $$(find $(BASHRC_D) -type f -name '*.bash'); do source $${f}; done; unset f; fi # dotfiles-installer' >> $(BASHFILE)

install: .makedir .link .hooks

install_copy: .makedir .copy .hooks

