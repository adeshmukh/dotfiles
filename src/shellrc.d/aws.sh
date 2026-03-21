# bash-only: tab completion for aws cli
[ -n "$BASH_VERSION" ] && [ -x "${HOME}/devel/bin/aws_completer" ] && \
    complete -C "${HOME}/devel/bin/aws_completer" aws

# CloudSearch
export CS_ENDPOINT=cloudsearch.us-east-1.amazonaws.com
export CS_HOME="${HOME}/devel/usr/local/cloud-search-tools-v2"
[ -d "$CS_HOME" ] && export PATH="${CS_HOME}/bin:${PATH}"
