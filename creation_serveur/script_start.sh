#!/bin/bash

usage() {
        echo "Usage : MC_Start.sh [OPTION]
        Start the chosen server

        -s      Start one particular server [OPTION] {server_name}
        -h      Print help message (this message)"
}

while getopts ":hs:" option; do
        case "${option}" in
                h)
                        usage
                        exit 0
                        ;;
                s)
                        name=$2
                        ;;
                *)
                        log error "Option ${option} not recognized."
                        usage
                        exit 1
                        ;;
        esac
done


if [ -z "$name" ]; then
        echo "error no server name enter"
        usage
        exit
else
        cd /Minecraft/Server/$name
        java -Xmx1024M -Xms1024M -jar $name.jar nogui
        cd /
fi