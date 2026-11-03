# Disable file completions by default
complete -c clone -f

complete -c clone -n __fish_is_first_token -d 'Git repository URL'
complete -c clone -n '__fish_is_token_n 2' -d 'Custom directory name'
complete -c clone -s d -l dir -r -d 'Base directory for cloning (default: ~/clones)'
complete -c clone -s h -l help -d 'Show help message'

# Common git hosts for convenience
complete -c clone -n __fish_is_first_token -a 'https://github.com/' -d 'GitHub HTTPS'
complete -c clone -n __fish_is_first_token -a 'git@github.com:' -d 'GitHub SSH'
complete -c clone -n __fish_is_first_token -a 'https://gitlab.com/' -d 'GitLab HTTPS'
complete -c clone -n __fish_is_first_token -a 'git@gitlab.com:' -d 'GitLab SSH'
complete -c clone -n __fish_is_first_token -a 'https://bitbucket.org/' -d 'Bitbucket HTTPS'
complete -c clone -n __fish_is_first_token -a 'git@bitbucket.org:' -d 'Bitbucket SSH'
complete -c clone -n __fish_is_first_token -a 'https://codeberg.org/' -d 'Codeberg HTTPS'
complete -c clone -n __fish_is_first_token -a 'git@codeberg.org:' -d 'Codeberg SSH'

# Directory completion for --dir
complete -c clone -l dir -a '(__fish_complete_directories)'

# User custom git hosts
if set -q clone_custom_hosts
    for i in (seq (count $clone_custom_hosts) -1 1)
        complete -c clone -n __fish_is_first_token -k -a $clone_custom_hosts[$i] -d "User provided $i"
    end
end
