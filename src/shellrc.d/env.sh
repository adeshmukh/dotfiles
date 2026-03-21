# Environment variables shared across all shells.
readonly basedir=~/devel
readonly repodir=${basedir}/repo

export PATH=~/.local/bin:$PATH
export CDPATH=$basedir:$repodir:$repodir/github.com:$repodir/github.com/adeshmukh
export GOPATH=$basedir/gopath
