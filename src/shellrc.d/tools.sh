# Tool initializations: nvm, pyenv, gcloud, aws.

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# gcloud
_gcloud_inc="${HOME}/devel/usr/local/google-cloud-sdk/path.bash.inc"
[ -f "$_gcloud_inc" ] && source "$_gcloud_inc"
unset _gcloud_inc

# aws: tab completion (bash-only)
[ -n "$BASH_VERSION" ] && [ -x "${HOME}/devel/bin/aws_completer" ] && \
    complete -C "${HOME}/devel/bin/aws_completer" aws

# CloudSearch
export CS_ENDPOINT=cloudsearch.us-east-1.amazonaws.com
export CS_HOME="${HOME}/devel/usr/local/cloud-search-tools-v2"
[ -d "$CS_HOME" ] && export PATH="${CS_HOME}/bin:${PATH}"

# gitignore
function gitignore() { curl -sLw \"\\\n\" https://www.toptal.com/developers/gitignore/api/\$@ ;}
