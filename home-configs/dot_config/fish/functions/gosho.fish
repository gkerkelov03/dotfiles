# ~/.config/fish/functions/cut-video.fish

function __cut_video_valid_time --argument-names value
    # remaining args are the allowed keywords (start, end, -)
    contains -- $value $argv[2..-1]; and return 0
    string match -qr '^(\d+:){0,2}\d+(\.\d+)?$' -- $value
end

function __cut_video_usage
    set -l title (gum style --bold --foreground 5 "✂  cut-video")
    set -l tagline (gum style --foreground 8 "Lossless video cutting with ffmpeg")
    set -l syntax (gum join --horizontal \
        (gum style --foreground 4 --bold "usage  ") \
        (gum style "cut-video " --foreground 7) \
        (gum style --foreground 6 "<FILE> <FROM> <TO>"))

    set -l keys (gum style --foreground 4 --bold -- \
        "FROM" "TO" | string collect)
    set -l vals (gum style --foreground 7 -- \
        "a time, or start / - / 0 for the beginning" \
        "a time, or end / - for the end of the file" | string collect)
    set -l args (gum join --horizontal $keys (gum style "  ") $vals | string collect)

    set -l cmds (gum style --foreground 6 -- \
        "cut-video test.mp4 5 10" \
        "cut-video test.mp4 1:30 2:30" \
        "cut-video test.mp4 00:01:30 00:02:30" \
        "cut-video test.mp4 1:30 150" \
        "cut-video test.mp4 1:30 end" \
        "cut-video test.mp4 start 1:30" \
        "cut-video" | string collect)
    set -l notes (gum style --foreground 8 -- \
        "# seconds" \
        "# minutes:seconds" \
        "# hours:minutes:seconds" \
        "# mixed formats work" \
        "# from 1:30 to the end (- works too)" \
        "# from the beginning to 1:30 (- or 0 too)" \
        "# no arguments: interactive mode" | string collect)
    set -l examples (gum join --horizontal $cmds (gum style "   ") $notes | string collect)

    gum style --border rounded --border-foreground 5 --padding "1 3" --margin "1 0" \
        (gum join --vertical --align left \
            $title $tagline "" $syntax "" $args "" \
            (gum style --foreground 4 --bold "examples") $examples | string collect) >&2
end

function gosho --description "Cut a video with ffmpeg (interactive when called without arguments)"
    if not command -q gum
        echo "cut-video: gum is not installed" >&2
        return 1
    end

    if contains -- "$argv[1]" -h --help
        __cut_video_usage
        return 0
    end

    set -l argc (count $argv)
    if test $argc -ne 0 -a $argc -ne 3
        gum style --foreground 1 --bold "✗ expected 3 arguments, got $argc" >&2
        __cut_video_usage
        return 1
    end

    set -l interactive 0
    set -l file
    set -l from
    set -l to

    if test $argc -eq 3
        set file $argv[1]
        set from $argv[2]
        set to $argv[3]
    else
        # ---- interactive mode ----
        if not isatty stdin
            gum style --foreground 1 --bold "✗ interactive mode needs a terminal" >&2
            return 1
        end
        set interactive 1

        gum style --bold --foreground 5 "✂  cut-video" >&2

        set -l videos (find . -maxdepth 2 -type f \( \
            -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.webm' -o -iname '*.mov' \
            -o -iname '*.avi' -o -iname '*.m4v' -o -iname '*.ts' \) \
            | string replace -r '^\./' '' | sort)
        if test (count $videos) -eq 0
            gum style --foreground 1 --bold "✗ no video files found here" >&2
            return 1
        end

        set file (printf '%s\n' $videos | gum filter \
            --header "Pick a video" --placeholder "type to filter…" --height 12)
        or return 130

        while true
            set from (gum input --header "From" --prompt "▸ " --value start \
                --placeholder "start · 5 · 1:30 · 00:01:30")
            or return 130
            __cut_video_valid_time "$from" start -; and break
            gum style --foreground 1 "✗ not a valid time: $from" >&2
        end

        while true
            set to (gum input --header "To" --prompt "▸ " --value end \
                --placeholder "end · 10 · 2:30 · 00:02:30")
            or return 130
            __cut_video_valid_time "$to" end -; and break
            gum style --foreground 1 "✗ not a valid time: $to" >&2
        end
    end

    # ---- validation ----
    if not test -f "$file"
        gum style --foreground 1 --bold "✗ file not found: $file" >&2
        return 1
    end
    if not __cut_video_valid_time "$from" start -
        gum style --foreground 1 --bold "✗ invalid FROM: $from" >&2
        return 1
    end
    if not __cut_video_valid_time "$to" end -
        gum style --foreground 1 --bold "✗ invalid TO: $to" >&2
        return 1
    end

    # FROM: "start", "-" or "0" = beginning. TO: "end" or "-" = end of file
    set -l ss_args
    set -l to_args
    set -l from_label start
    set -l to_label end
    if not contains -- $from start - 0
        set ss_args -ss $from
        set from_label $from
    end
    if not contains -- $to end -
        set to_args -to $to
        set to_label $to
    end

    set -l dir (path dirname -- $file)
    set -l base (path basename -- $file)
    set -l ext (path extension -- $base)
    set -l name (path change-extension '' -- $base)

    # Find a free name: name-cut.ext, name-cut2.ext, name-cut3.ext, ...
    set -l out "$dir/$name-cut$ext"
    set -l n 2
    while test -e "$out"
        set out "$dir/$name-cut$n$ext"
        set n (math $n + 1)
    end

    # ---- summary card ----
    set -l labels (gum style --foreground 8 -- "input" "from" "to" "output" | string collect)
    set -l values (gum style --foreground 7 -- $file $from_label $to_label $out | string collect)
    gum style --border rounded --border-foreground 5 --padding "0 2" --margin "1 0" \
        (gum join --horizontal $labels (gum style "   ") $values | string collect) >&2

    if test $interactive -eq 1
        gum confirm "Cut it?" --default=yes; or return 130
    end

    # ---- run ffmpeg ----
    gum spin --spinner dot --title "Cutting $base…" --show-error -- \
        ffmpeg -hide_banner -loglevel error -nostats $ss_args $to_args \
        -i $file -c copy -avoid_negative_ts make_zero $out
    set -l st $status

    if test $st -ne 0
        rm -f $out
        gum style --foreground 1 --bold "✗ ffmpeg failed" >&2
        return $st
    end

    set -l size (du -h -- $out | string split -f1 \t)
    gum join --horizontal \
        (gum style --foreground 2 --bold "✓ Saved  ") \
        (gum style --foreground 7 $out) \
        (gum style --foreground 8 "  ($size)") >&2

    # Only print the bare path when captured, e.g. set x (cut-video f 1 2)
    isatty stdout; or echo $out
end
