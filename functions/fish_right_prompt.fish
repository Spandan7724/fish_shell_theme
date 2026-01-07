function fish_right_prompt
  set -l time_color (set_color 6e6a86)
  set -l normal_color (set_color normal)
  echo -n -s $time_color (date "+%H:%M:%S") $normal_color
end
