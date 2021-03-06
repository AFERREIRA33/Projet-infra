#!/bin/bash

opt=true

usage() {
        echo "Usage : MC_Start.sh [OPTION]
        Stop the chosen server or all of them

        -s      Start one particular server
        -h      Print help message (this message)"
}

while getopts ":hs:" option; do
        case "${option}" in
                h)
                        usage
                        exit 0
                        ;;
                s)
                        opt=false
                        name=$2
                        ;;
                *)
                        log error "Option ${option} not recognized."
                        usage
                        exit 1
                        ;;
        esac
done

if [ "$opt" = true ]; then
        killserv=$(ps -eo %p%c | grep java |cut -d"j" -f1)
        kill -KILL $killserv
elif [ "$opt" = false ]; then
        killserv=$(ps -ef | grep "$name" | cut -c10-16 | head -1)
        kill -KILL $killserv
fi