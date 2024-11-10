# Nushell Environment Config File
#
# version = "0.99.1"

def create_left_prompt [] {
    let hostname = ^hostname
    
    # == [USER@HOSTNAME:<PATH>] (Like bash)
    def create_boiler_plate [fmt: string] { [([$env.USER, "@", $hostname, ":", $fmt] | str join)] }

    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => (create_boiler_plate $env.PWD)
        '' => (create_boiler_plate '~')
        $relative_pwd => (create_boiler_plate ([~ $relative_pwd] | path join))
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_INDICATOR = {|| "$ " }
