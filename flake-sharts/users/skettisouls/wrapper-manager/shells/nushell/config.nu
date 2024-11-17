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

load-env {
    "EDITOR": "nvim",
}

$env.config = {
    show_banner: false
    completions: {
        external: (if ((which carapace | length) > 0) {
            {
                enable: true
                completer: {|spans| carapace $spans.0 nushell ...$spans | from json}
                max_results: 100
            }
        } else {
            {}
        })
    }
    hooks: {
        env_change: {
            PWD: {||
                if (which direnv | is-empty) {
                    return
                }

                direnv export json | from json | default {} | load-env
            }
        }
    }
}
