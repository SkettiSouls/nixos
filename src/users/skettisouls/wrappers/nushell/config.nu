# Nushell Config File
#
# version = "0.99.1"

# Remove all files in the current directory, except for the provided file names.
def rm-except [exceptions: list<string>] { ls | where name not-in $exceptions | each { rm $in.name } o> /dev/null }

$env.DIR_STACK = []
def --env pushd [path: string] {
  if ($env.DIR_STACK | length) == 0 {
    $env.DIR_STACK ++= append (pwd)
  }

  $env.DIR_STACK ++= [ $path ]
  cd $path
}

def --env popd [] {
  if ($env.DIR_STACK | length) == 0 {
    error make {msg: "Error: Directory stack empty"}
    return
  }

  $env.DIR_STACK = $env.DIR_STACK | drop
  $env.DIR_STACK | last | cd $in

  if ($env.DIR_STACK | length) == 1 {
    $env.DIR_STACK = []
  }
}

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
  hooks: {
    env_change: {
      PWD: [{ ||
        if (which direnv | is-empty) {
          return
        }

        direnv export json | from json | default {} | if "PATH" in $in {
          # Fix PATH getting broken
          load-env ($in | merge {
            "PATH": ($in.PATH | split row ":")
          })
        }
      }]
    }
  }
}
