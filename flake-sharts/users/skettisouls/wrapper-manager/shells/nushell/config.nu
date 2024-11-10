# Nushell Config File
#
# version = "0.99.1"

# Remove all files in the current directory, except for the provided file names.
def rm-except [xcpt: list<string>] { ls | where name not-in $xcpt | each { rm $in.name } o> /dev/null }

alias ':q' = exit
alias l = ls -l
alias la = ls -a
alias lla = ls -la
alias icat = kitten icat

$env.config = {
    show_banner: false
}
