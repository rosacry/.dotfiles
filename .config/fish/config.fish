source ~/.config/fish/alias.fish
source ~/.config/fish/activate.fish
#set JAVA_HOME $(/usr/libexec/java_home)
set EDITOR 'nvim'

# Configure Jump
status --is-interactive; and source (jump shell fish | psub)


#fish vi mode
fish_vi_key_bindings
set -g fish_escape_delay_ms 10

# Colorscheme: (Almost) No Colors
set -U fish_color_normal normal
set -U fish_color_command
set -U fish_color_quote
set -U fish_color_redirection
set -U fish_color_end
set -U fish_color_error
set -U fish_color_param
set -U fish_color_comment
set -U fish_color_match
set -U fish_color_selection --reverse
set -U fish_color_search_match --reverse
set -U fish_color_history_current
set -U fish_color_operator
set -U fish_color_escape
set -U fish_color_cwd normal
set -U fish_color_cwd_root normal
set -U fish_color_valid_path
set -U fish_color_autosuggestion brblack
set -U fish_color_user normal
set -U fish_color_host normal
set -U fish_color_cancel
set -U fish_pager_color_prefix --underline
set -U fish_pager_color_progress brblack
set -U fish_pager_color_completion normal
set -U fish_pager_color_description brblack
set -U fish_pager_color_selected_background --reverse

alias python='python3'
alias vim='nvim'
#alias matlab="/Applications/MATLAB_R2021b.app/bin/matlab -nodesktop"

# git add, commit and push commands in one line :)
function gitt
 	git --git-dir=$PWD/.git add . # Stage all unstaged files
	git --git-dir=$PWD/.git commit -a -m $argv # Commit files with the given argument as the commit message
	git --git-dir=$PWD/.git push # Push to remote
end

function gittU
  git push --set-upstream origin master
end

function stoww
  stow --adopt -t ~/ .
  echo "Stow Complete"
end


function ignore
  if test -e $argv
    git reset $argv
    git rm --cached $argv
    if not test -e .gitignore
      touch .gitignore
    end
    echo "$argv" >> .gitignore
    echo "$argv ignored from git"
  else
    echo "$argv not found!"
  end
end

function unignore
  if test -e $argv; and grep -r $argv .gitignore
    sed -i .bak "/$argv/d" .gitignore
    echo "$argv removed from .gitignore"
  else
    echo "$argv is either not in either directory and/or in .gitignore!"
  end
end

# Install Starship
starship init fish | source

#xmodmap commands

#set -gx PATH /usr/local/bin $PATH
#set -gx TERM xterm-256color
#set -gx UID (id -u)
#set -gx EUID (id -u)
