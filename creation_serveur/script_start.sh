#!/bin/bash

opt=true

usage() {
        echo "Usage : MC_Start.sh [OPTION]
        Start the chosen server or all of them

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
        cd /Minecraft/Server/BungeeCord
        tmux new-session -d -s bungeecord java -Xmx512M -Xms512M -jar BungeeCord.jar
        cd /
        cat /Minecraft/Minecraftinput/servername | while read -r line; do
                cd /Minecraft/Server/$line
                tmux new-session -d -s $line java -Xmx1024M -Xms1024M -jar $line.jar nogui
                cd /
        done
elif [ "$opt" = false ]; then
        cd /Minecraft/Server/$name
        java -Xmx1024M -Xms1024M -jar $name.jar nogui
        cd /
fi