function cut-video --description "Cut a video with ffmpeg: "
    if test (count $argv) -ne 3
        echo "Usage: cut-video <FILE> <FROM> <TO>" >&2
        echo "" >&2
        echo "  FROM: a time, or 'start' (or '-' or '0') for the beginning" >&2
        echo "  TO:   a time, or 'end' (or '-') for the end of the file" >&2
        echo "" >&2
        echo "Examples:" >&2
        echo "  cut-video test.mp4 5 10                # seconds" >&2
        echo "  cut-video test.mp4 1:30 2:30           # minutes:seconds" >&2
        echo "  cut-video test.mp4 00:01:30 00:02:30   # hours:minutes:seconds" >&2
        echo "  cut-video test.mp4 1:30 150            # mixed also works" >&2
        echo "  cut-video test.mp4 1:30 end            # from 1:30 to the end" >&2
        echo "  cut-video test.mp4 1:30 -              # same, using -" >&2
        echo "  cut-video test.mp4 start 1:30          # from the beginning to 1:30" >&2
        echo "  cut-video test.mp4 - 1:30              # same, using -" >&2
        echo "  cut-video test.mp4 0 1:30              # same, using 0" >&2
        return 1
    end

    set -l file $argv[1]
    set -l from $argv[2]
    set -l to $argv[3]

    if not test -f "$file"
        echo "file not found: $file" >&2
        return 1
    end

    # FROM: "start", "-" or "0" = beginning. TO: "end" or "-" = end of file
    set -l ss_args
    set -l to_args
    if not contains -- $from start - 0
        set ss_args -ss $from
    end
    if not contains -- $to end -
        set to_args -to $to
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

    ffmpeg -hide_banner -loglevel error -nostats $ss_args $to_args -i $file -c copy -avoid_negative_ts make_zero $out
    and echo "Saved: $out"
end
