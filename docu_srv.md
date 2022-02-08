# Documentation d'instalation des serveurs minecrafts

## Sommaire

- [Prérequis](#p0)
- [Création des serveurs](#p1)
- [Lancement des serveurs](#p2)
- [Création de la backup](#p3) 
    - [Prérequis](#p3.1)
    - [Récupération du script](#p3.2)

## Prérequis <a name="p0"></a>

Machines : 2 (serveur / backup)
Go de RAM :
CPU :
OS : Rocky linux

## Création des serveurs <a name="p1"></a>

## Lancement des serveurs <a name="p2"></a>

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




