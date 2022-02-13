#!/bin/bash

usage() {
        echo "Usage : MC_Start.sh [OPTION]
        Stop the chosen server or all of them

        -l      Show listening port
        -m      Show Memory information
        -c      Show The CPU usage
        -f      Show the Firewall Status
        -d      Show disk usage
        -h      Print help message (this message)"
}

while getopts ":lmdcfh:" option; do
        case "${option}" in
                h)
                        usage
                        exit 0
                        ;;
                l)
                        portlisten="$(netstat -l)"
                        echo "$portlisten"
                        ;;
                m)
                        mem="$(free -mh)"
                        echo "$mem"
                        ;;
                d)
                        disk="$(df -h)"
                        echo "$disk"
                        ;;
                c)
                        cpu=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
                        date=$(date "+%Y-%m-%d %H:%M:")
                        cpu_usage="$date CPU: $cpu"
                        echo $cpu_usage > /opt/cpu.out
                        cat /opt/cpu.out
                        ;;
                f)
                        firewall="$(firewall-cmd --state)"
                        echo "$firewall"
                        ;;
                *)
                        log error "Option ${option} not recognized."
                        usage
                        exit 1
                        ;;
        esac
done