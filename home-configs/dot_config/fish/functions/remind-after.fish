function reminder-after --description "Send a desktop notification after a delay"
    set -l usage \
        "usage: reminder-after <time> <message>" \
        "  time must include a unit:" \
        "    30s       30 seconds" \
        "    5m        5 minutes" \
        "    2h        2 hours" \
        "    1d        1 day" \
        "    1h20m     combined: 1 hour 20 minutes" \
        "    2d4h      combined: 2 days 4 hours" \
        "    2d4h10m   combined: 2 days 4 hours 10 minutes"

    if test (count $argv) -lt 2
        printf '%s\n' $usage
        return 1
    end

    set -l when $argv[1]
    set -l msg $argv[2..-1]

    # reject plain numbers, a unit is mandatory
    if string match -qr '^\d+$' -- $when
        echo "missing unit: $when" >&2
        printf '%s\n' $usage
        return 1
    end

    # validate the time span before scheduling
    if not systemd-analyze timespan $when >/dev/null 2>&1
        echo "invalid time: $when" >&2
        printf '%s\n' $usage
        return 1
    end

    systemd-run --user --quiet --on-active=$when \
        notify-send -a Reminder -i alarm-clock Reminder "$msg"
    and echo "reminder set for $when from now: $msg"
end
