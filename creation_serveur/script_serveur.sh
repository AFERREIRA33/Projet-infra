#!/bin/bash

#Script bash install d'un serveur MC fonctionel sur Rocky.
#Ce script vous permet de crée un serveur sous spigot et configurer pour communiquer entre eux via BungeeCord.
#Si vous utiliser se script pour la premiére fois il installera automatiquement java et BungeeCord.
#Penser à rentrer en premier argument le nom pour votre serveur puis en second argument le port sur lequel vous voulez mettre votre serveur.

if [ -d /etc/java ]
then
        echo "Java is already install"
else
        dnf -y install java-17-openjdk.x86_64
fi

if [ -f /etc/wgetrc ]
then
        echo "wget is already install"
else
        dnf -y install wget
fi

if [ -d /tmp/tmux-1000 ]
then
        echo "tmux is already install"
else
        dnf -y install tmux
fi

if [ -d /Minecraft ]
then
        echo "Minecraft directory exist"
else
        mkdir /Minecraft
fi

if [ -d /Minecraft/Server ]
then
        echo "server directory exist"
else
        mkdir /Minecraft/Server
fi

if [ -d /var/log/MC ]; then
        echo "log directory exist"
else
        mkdir /var/log/MC
        touch /var/log/MC/serveurMC.log
fi

if [ -d /Minecraft/Minecraftinput ]
then
        echo "Minecraft directory exist"
else
        mkdir /Minecraft/Minecraftinput
fi

if [ -f /Minecraft/Minecraftinput/servername ]
then
        echo "file servername exist"
else
        touch /Minecraft/Minecraftinput/servername
fi

if [ -f /Minecraft/inputMC ]; then
        echo "input file exist"
else
        touch /Minecraft/inputMC
        echo "[$(date "+%Y/%m/%d %T")] file /Minecraft/inputMC created please put the name of your server in it" >> "/var/log/MC/serveurMC.log"
        exit
fi

if [ -f /Minecraft/Minecraftinput/PortMC ]; then
        echo "file PortMC exist"
else
        echo "25565" > /Minecraft/Minecraftinput/PortMC
fi

declare -i nbline=1
declare -i nbline1=0
declare -i nbline2=0
declare -i nbline3=0
declare -i nbline4=0
cat /Minecraft/inputMC | while read -r lineNAME; do
        name=$lineNAME
        echo "$name" >> /Minecraft/Minecraftinput/servername
        cat /Minecraft/Minecraftinput/PortMC | while read -r linePORT; do
                portmc=$((linePORT + 1))
                port=$portmc
                echo "$portmc" > /Minecraft/Minecraftinput/PortMC
                nbline=1
                nbline1=0
                nbline2=0
                nbline3=0
                nbline4=0

                if [ -d /Minecraft/Server/BungeeCord ]
                then
                        echo "BungeeCord est déja installer sur votre machine"
                else
                        mkdir /Minecraft/Server/BungeeCord
                        wget -P /Minecraft/Server/BungeeCord https://ci.md-5.net/job/BungeeCord/1628/artifact/bootstrap/target/BungeeCord.jar
                        cd /Minecraft/Server/BungeeCord
                        tmux new-session -d -s bungeecord java -Xmx512M -Xms512M -jar BungeeCord.jar
                        firewall-cmd --add-port=25565/tcp --permanent
                        firewall-cmd --add-port=25565/udp --permanent
                        firewall-cmd --reload
                        cd /
                        sleep 30
                        kill=$(ps -eo %p%c | grep java |cut -d"j" -f1)
                        kill $kill
                        sed -i 's/ip_forward: false/ip_forward: true/g' /Minecraft/Server/BungeeCord/config.yml
                        sed -i 's/  host: 0.0.0.0:25577/  host: 0.0.0.0:25565/g' /Minecraft/Server/BungeeCord/config.yml
                fi
                mkdir /Minecraft/Server/$name
                echo "eula=true" > /Minecraft/Server/$name/eula.txt
                wget -P /Minecraft/Server/$name https://download.getbukkit.org/spigot/spigot-1.18.1.jar
                cd /Minecraft/Server/$name
                mv spigot-1.18.1.jar $name.jar
                tmux new-session -d -s serveur java -Xmx1024M -Xms1024M -jar $name.jar nogui
                sleep 60
                cd /
                killserv=$(ps -eo %p%c | grep java |cut -d"j" -f1)
                kill -KILL $killserv
                sed -i 's/online-mode=true/online-mode=false/g' /Minecraft/Server/$name/server.properties
                sed -i 's/server-ip=/server-ip=127.0.0.1/g' /Minecraft/Server/$name/server.properties
                sed -i 's/server-port=25565/server-port='$port'/g' /Minecraft/Server/$name/server.properties
                sed -i 's/  bungeecord: false/  bungeecord: true/g' /Minecraft/Server/$name/spigot.yml
                sed -i 's/  connection-throttle: 4000/  connection-throttle: -1/g' /Minecraft/Server/$name/bukkit.yml
                firewall-cmd --add-port=$port/tcp --permanent
                firewall-cmd --add-port=$port/udp --permanent
                firewall-cmd --reload
                cat /Minecraft/Server/BungeeCord/config.yml | while read -r line; do
                        if [[ "$line" == "servers:" ]]; then
                                nbline1=nbline+1
                                nbline2=nbline+2
                                nbline3=nbline+3
                                nbline4=nbline+4
                                sudo sed -i ''$nbline1' i \  '$name':' /Minecraft/Server/BungeeCord/config.yml
                                sudo sed -i ''$nbline2' i \    motd: "&1Just another BungeeCord - Forced Host"' /Minecraft/Server/BungeeCord/config.yml
                                sudo sed -i ''$nbline3' i \    address: localhost:'$port'' /Minecraft/Server/BungeeCord/config.yml
                                sudo sed -i ''$nbline4' i \    restricted: false' /Minecraft/Server/BungeeCord/config.yml
                        else
                                nbline=nbline+1
                        fi
                done
                echo "[$(date "+%Y/%m/%d %T")] Serveur Minecraft $name has been created with Port: $portmc" >> "/var/log/MC/serveurMC.log"
        done
        sed -i '1d' "/Minecraft/inputMC"
done
