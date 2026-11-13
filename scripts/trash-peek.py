#!/usr/bin/env python3
"""trash-peek used by the tv trash channel as a previewer.
I have no idea how it works but it uses eza and bat to preview
If you have problems with it just figure out another previewer for the trash channel of tv
It doesn't even have to have one its just nice to have so don't waste time with it if it breaks

Looks in the home trash and in every mounted volume's .Trash/$UID and .Trash-$UID,
following the FreeDesktop.org Trash spec.
"""

import os
import re
import sys
from urllib.parse import unquote


def mount_points():
    try:
        with open("/proc/self/mounts") as f:
            for line in f:
                parts = line.split()
                if len(parts) > 1:
                    # /proc/mounts escapes space, tab, newline, backslash as octal (\040 etc.)
                    yield re.sub(
                        r"\\([0-7]{3})", lambda m: chr(int(m.group(1), 8)), parts[1]
                    )
    except OSError:
        return


def trash_dirs():
    """Yield (trash_dir, topdir); topdir is None for the home trash (absolute Paths)."""
    data_home = os.environ.get("XDG_DATA_HOME") or os.path.expanduser("~/.local/share")
    yield os.path.join(data_home, "Trash"), None
    uid = str(os.getuid())
    seen = set()
    for top in mount_points():
        if top in seen:
            continue
        seen.add(top)
        for d in (os.path.join(top, ".Trash", uid), os.path.join(top, ".Trash-" + uid)):
            if os.path.isdir(os.path.join(d, "info")):
                yield d, top


def read_info(path):
    orig = date = None
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            for line in f:
                line = line.rstrip("\n")
                if line.startswith("Path="):
                    orig = unquote(line[5:])
                elif line.startswith("DeletionDate="):
                    date = line[13:]
    except OSError:
        pass
    return orig, date


def locate(entry):
    parts = entry.strip().split(" ", 2)
    if len(parts) != 3:
        return None
    want_date = parts[0] + "T" + parts[1]
    want_path = parts[2]
    for tdir, top in trash_dirs():
        info_dir = os.path.join(tdir, "info")
        try:
            names = os.listdir(info_dir)
        except OSError:
            continue
        for name in names:
            if not name.endswith(".trashinfo"):
                continue
            orig, date = read_info(os.path.join(info_dir, name))
            if orig is None or date is None:
                continue
            if top is not None and not orig.startswith("/"):
                orig = os.path.join(top, orig)
            # some implementations write fractional seconds; compare to the second
            if (
                os.path.normpath(orig) == os.path.normpath(want_path)
                and date[:19] == want_date
            ):
                item = os.path.join(tdir, "files", name[: -len(".trashinfo")])
                if os.path.lexists(item):
                    return item
    return None


def preview(item):
    if os.path.isdir(item) and not os.path.islink(item):
        cmd = [
            "eza",
            "--tree",
            "--level=2",
            "--color=always",
            "--icons=always",
            "--group-directories-first",
            item,
        ]
    else:
        cmd = ["bat", "--color=always", "--style=numbers", "--paging=never", item]
    os.execvp(cmd[0], cmd)  # hand over to bat/eza


def main():
    args = sys.argv[1:]
    want_path = False
    if args and args[0] == "--path":
        want_path = True
        args = args[1:]
    if len(args) != 1:
        print((__doc__ or "").strip(), file=sys.stderr)
        sys.exit(2)
    item = locate(args[0])
    if item is None:
        print("not found in trash", file=sys.stderr)
        sys.exit(1)
    if want_path:
        print(item)
    else:
        preview(item)


if __name__ == "__main__":
    main()
