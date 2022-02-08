# Documentation d'instalation des serveurs minecrafts

## Sommaire

- [Prérequis](#p0)
- [Création des serveurs](#p1)
- [Lancement des serveurs](#p2)
- [Création de la backup](#p3) 
    - [Prérequis](#p3.1)

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
mettre le fichier [save.sh](./backub/save.sh) dans le dossier "/srv/save".



