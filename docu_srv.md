# Documentation d'instalation des serveurs minecraft

## Sommaire

- [Prérequis](#p0)
- [Création des serveurs](#p1)
    - [Récupération des scripts](#p1.1)
    - [Initialisation](#p1.2)
    - [Création d’un serveur Minecraft](#p1.3)
- [Lancement et arrêt des serveurs](#p2)
    - [Récupération des scripts](#p2.1)
    - [Lancer un serveur](#p2.2)
    - [Arreter un serveur](#p2.3)
- [Création de la backup](#p3) 
    - [Prérequis](#p3.1)
    - [Récupération du script](#p3.2)

## Prérequis <a name="p0"></a>

Machines : 2 (serveur / backup)  
Go de RAM :  
CPU :  
OS : Rocky linux  

## Création des serveurs <a name="p1"></a>

### Récupération des scripts <a name="p1.1"></a>
Pour installer un nouveau serveur Minecraft commencer par télécharger les scripts suivants :

[script_serveur.sh](creation_serveur/script_serveur.sh)

[serveur.service](creation_serveur/serveur.service)

### Initialisation <a name="p1.2"></a>
A présent lancer le service une première fois à l’aide de ses commandes :
```
sudo systemctl daemon-reload
sudo systemctl start serveur.service
```

Une fois cela fait patienter quelques instants. Un dossier « /Minecraft » devrait avoir été crée à la racine si c’est le cas c’est que tout s’est bien passée et que le script c’est correctement initialiser.

### Création d’un serveur Minecraft <a name="p1.3"></a>
A partir de maintenant vous pouvez répéter les opérations suivantes autant de fois que nécessaire pour chaque serveur supplémentaire que vous désirez crée.
Rendez-vous dans le dossier : « /Minecraft/Minecraftinput » vous devrez y trouver un fichier nommé : « servername », se fichier sert à indiquer au programme les noms que vous voulez donnée à vos serveurs Minecraft. Ouvrez se fichier avec l’éditeur de votre choix et indiquer le nom voulu pour vos serveur (un nom par ligne).
Quitter ensuite se fichier et relancer le service avec la commande suivante :
```
sudo systemctl start serveur.service
```
N’hésitez pas à vérifier que votre service est bien actif avec la commande suivante :
```
sudo systemctl status serveur.service
```
Patientez ensuite jusqu’as ce que le service soit arrêter (cette opération peut prendre plusieurs minutes).
Vérifier ensuite que votre serveur est bien installé en vous rendant dans le fichier des logs d’installation « "/var/log/MC/serveurMC.log" » vous devriez voir dedans une ligne avec la date, le nom de votre serveur et son port.


## Lancement et arrêt des serveurs <a name="p2"></a>

### Récupération des scripts <a name="p2.1"></a>

Pour lancer et arreter vos serveur Minecraft commencer par télécharger les scripts suivants :

[script_start.sh](creation_serveur/script_start.sh)

[script_stop.sh](creation_serveur/script_stop.sh)

### Lancer un serveur <a name="p2.2"></a>



### Arreter un serveur <a name="p2.3"></a>



## Création du service de backup <a name="p3"></a>

### Prérequis <a name="p3.1"></a>

installer rsync :
```bash
sudoyum -y install ssh rsync
sudo dnf install ssh rsync
```
il faut effectuer un échange de clé ssh depuis la backup vers le server ssh avec le user qui gèrera la backup d'un coté et le seerveur de l'autre.

### Récupération du script <a name="p3.2"></a>

créer le fichier "/srv/save":
```bash
mkdir /srv/save
```

Mettre le fichier [save.sh](./backup/save.sh) dans le dossier "/srv/save".

Modifier dans le fichier la ligne du serveur en mettant le nom de l'utilisateur, l'adresse ip du serveur dont on fait la copie:
```bash
server="<user@ip>:/minecraft"
```

### Récupération du service et du timer qui lance la backup <a name="p3.3"></a>

Mettre le fichier [backup.service](./backup/backup.service) et le fichier [backup.timer](./backup/backup.timer) dans le dossier "/etc/systemd/system/"

Pour modifier le temps entre les backup il faut modifier cette ligne dans [backup.timer](./backup/backup.timer) :
```
OnCalendar=hourly
```

Pour démarrer le service, faites les commandes suivante :
```bash
sudo systemctl daemon-reload
sudo systemctl start backup.timer
```




