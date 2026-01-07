# Rosé Pine Theme for Oh My Fish
# You can override some default options with config.fish:
#
#  set -g theme_short_path yes
#  set -g theme_stash_indicator yes
#  set -g theme_ignore_ssh_awareness yes

function fish_prompt
  set -l last_command_status $status
  set -l cwd

  if test "$theme_short_path" = 'yes'
    set cwd (basename (prompt_pwd))
  else
    set cwd (prompt_pwd)
  end

  set -l fish     "⋊>"
  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄"
  set -l dirty    "⨯"
  set -l stash    "≡"
  set -l none     "◦"

  set -l normal_color     (set_color normal)
  set -l success_color    (set_color 9ccfd8)
  set -l error_color      (set_color eb6f92 --bold)
  set -l directory_color  (set_color 31748f)
  set -l repository_color (set_color b6e4ea --bold)
  set -l git_dirty_color  (set_color f6c177)
  set -l git_ahead_color  (set_color 9ccfd8)
  set -l git_behind_color (set_color eb6f92)
  set -l git_diverged_color (set_color ebbcba)
  set -l git_clean_color  (set_color 6e6a86)
  set -l git_stash_color  (set_color f6c177)
  set -l ssh_user_color   (set_color ebbcba --bold)
  set -l ssh_separator    (set_color 6e6a86)
  set -l accent_color     (set_color 6e6a86)

  set -l prompt_string $fish

  if test "$theme_ignore_ssh_awareness" != 'yes' -a -n "$SSH_CLIENT$SSH_TTY"
    if test $last_command_status -eq 0
      echo -n -s $success_color $fish $normal_color " "
    else
      echo -n -s $error_color $fish $normal_color " "
    end
    echo -n -s $ssh_user_color (whoami) $ssh_separator "@" $ssh_user_color (hostname -s) " " $success_color $fish $normal_color
  else
    if test $last_command_status -eq 0
      echo -n -s $success_color $prompt_string $normal_color
    else
      echo -n -s $error_color $prompt_string $normal_color
    end
  end

  if git_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command git rev-parse --show-toplevel 2> /dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    end

    echo -n -s " " $directory_color $cwd $normal_color
    echo -n -s " " $accent_color "on" $normal_color " " $repository_color (git_branch_name) $normal_color " "

    set -l status_output

    if test "$theme_stash_indicator" = yes; and git_is_stashed
      set status_output $status_output $git_stash_color $stash $normal_color
    end

    if git_is_touched
      set status_output $status_output $git_dirty_color $dirty $normal_color
    end

    if test -n "$status_output"
      echo -n -s $status_output
    else
      set -l git_status (git_ahead $ahead $behind $diverged $none)
      if test "$git_status" = "$ahead"
        echo -n -s $git_ahead_color $git_status $normal_color
      else if test "$git_status" = "$behind"
        echo -n -s $git_behind_color $git_status $normal_color
      else if test "$git_status" = "$diverged"
        echo -n -s $git_diverged_color $git_status $normal_color
      else
        echo -n -s $git_clean_color $git_status $normal_color
      end
    end
  else
    echo -n -s " " $directory_color $cwd $normal_color
  end

  echo -n -s " "
end
