import os
from libqtile import bar, layout, widget, qtile
from libqtile.config import Key, Group, Screen, Match
from libqtile.lazy import lazy

mod = "mod4"
terminal = "kitty"
directions = {"h": "left", "l": "right", "j": "down", "k": "up"}
keys = [
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "o", lazy.spawn("rofi -show drun"), desc="Open launcher"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle layouts"),
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle split/unsplit"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"), 
]

for key, dir in directions.items():
    keys.append(Key([mod], key, getattr(lazy.layout, dir)(), desc=f"Move focus {dir}"))
    keys.append(Key([mod, "shift"], key, getattr(lazy.layout, f"shuffle_{dir}")(), desc=f"Move window {dir}"))
    keys.append(Key([mod, "control"], key, getattr(lazy.layout, f"grow_{dir}")(), desc=f"Grow window {dir}"))

groups = [Group(str(i)) for i in range(1, 6)]
for g in groups:
    keys.extend([
        Key([mod], g.name, lazy.group[g.name].toscreen(), desc=f"Switch to group {g.name}"),
        Key([mod, "shift"], g.name, lazy.window.togroup(g.name), desc=f"Move window to group {g.name}"),
    ])

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=2),
    layout.Max(),
]

widget_defaults = dict(font="sans", fontsize=12, padding=3)
extension_defaults = widget_defaults.copy()

status_bar_widgets_list = [
    widget.CurrentLayout(),
    widget.GroupBox(),
    widget.Systray(),
    widget.Clock(format="%Y-%m-%d %a %I:%M %p")
]
status_bar = bar.Bar(status_bar_widgets_list, 15)
screens = [Screen(bottom=status_bar)]

wmname = "LG3D"                         # Fix Java GUI apps
focus_on_window_activation = "smart"    # Focus new windows only when appropriate (avoids focus stealing)
dgroups_key_binder = None               # Disable automatic workspace keybindings (we define our own)
cursor_warp = False                     # Prevent mouse from jumping when changing focus
follow_mouse_focus = True               # Move focus when mouse hovers over a window
floats_kept_above = True                # Floating windows stay above tiled windows
auto_fullscreen = True                  # Allow apps to enter fullscreen properly
reconfigure_screens = True              # Detect monitor changes automatically (useful in VMs)

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="ssh-askpass"),
        Match(title="pinentry"),
    ]
)

