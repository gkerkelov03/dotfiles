#!/usr/bin/fish

# 1. Run the Tide configuration wizard with your specific flags
tide configure --auto --style=Rainbow --prompt_colors='16 colors' --show_time=No --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Sharp --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Dotted --powerline_right_prompt_frame=Yes --prompt_spacing=Sparse --icons='Many icons' --transient=No

# 2. Apply your custom overrides immediately after
set -Ux tide_character_icon \U000f016c
set -Ux tide_character_vi_icon_default \U000f016c
set -Ux tide_character_vi_icon_insert \U000f016c

echo "Done! You probably need to restart the terminal"
