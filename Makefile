BASHRC_D=$(HOME)/.bashrc.d
BASHFILE=$(HOME)/.bashrc
SRCDIR=$(PWD)/src


# --- .bashrc.d
.bashrcd_makedir:
	mkdir -p $(BASHRC_D)

.bashrcd_ln:
	ln -Fis $(SRCDIR)/bashrc.d $(BASHRC_D)

.bashrcd_cp:
	cp -rf $(SRCDIR)/bashrc.d/* $(BASHRC_D)

.bashrcd_hooks:
	echo 'if [ -z "$$PS1" ]; then return; else for f in $$(find $(BASHRC_D)/ -type f -name '*.bash'); do source $${f}; done; unset f; fi # dotfiles-installer' >> $(BASHFILE)

.bashrcd_link: .bashrcd_makedir .bashrcd_ln .bashrcd_hooks

.bashrcd_copy: .bashrcd_makedir .bashrcd_cp .bashrcd_hooks


# --- dotfiles
.dotfiles_link:
	for f in $$(find $(SRCDIR) -maxdepth 1 -type f); do ln -Fis $${f} $${HOME}/.$$(basename $${f}); done
	
.dotfiles_copy:
	for f in $$(find $(SRCDIR) -maxdepth 1 -type f); do cp -vf $${f} $${HOME}/.$$(basename $${f}); done

# --- Main goals
install: .bashrcd_link .dotfiles_link

install_copy: .bashrcd_copy .dotfiles_copy

