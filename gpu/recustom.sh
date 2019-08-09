#!/bin/bash
####################################
# Changelog:
#Version 1:
#*- podstatwowy skrypt w pelni dzialajacy
#*- CZYSCI FOLDER HOME/ETHOS
#*- CZYSCI LOGI CLAYMORE
#*- SPRAWDZA JAKIE JEST IP
#*- SPRAWDZA DATE I WYPISUJE DO PLIKU (debug.txt)
#*- USUWA TEAMVIEWER 
#Version 1.1:
#*- USUWA TEAMVIEWER z wersji 1 (usuniete) 
#Version 1.2:
#*- PLIKI SHELL SA POBIERANE PRZEZ .bashrc 
#Version 1.3:
#*- USUNIECIE BLEDU POBIERANIA remote.conf W recustom.sh 
#Version 1.4:
#*- Naprawa HASH-MONITOR (bledne ID gpu wysyla na ftp) 
#*-  
#####!!!***@~~~ W /home/ethos/.bashrc NA SAMYM DOLE SA OPCJE POBIERANIA PLIKOW Z SERVERA 
#####!!!***@~~~ PLIK recustom.sh ODPOWIADA ZA SKRYPTY ODPALANE ZA KAZDYM URUCHOMIENIEM KOPARKI
#####!!!***@~~~ ABY KOPARKI POBRALY JEDNORAZOWO customscript.sh i recustom.sh TRZEBA ZMIENIC VERSCRIPT.SH NA WYZSZA WERSJE

################################################# SPRAWDZA JAKIE JEST IP CZY 192.168.X.X CZY 10.X.X.X I SCIAGA ODPOWIEDNI REMOTE.CONF

IP=$(/opt/ethos/sbin/ethos-readdata ip | cut -d "." -f 1)
if [ "$IP" != "10" ]; then
    GITHUBLIVE=$(curl -m 5 -s --head  --request GET https://jooni22.github.io/ethoscfg/ciolkowskiego.txt | grep "200 OK" | cut -d " " -f 2);
    if [ "$GITHUBLIVE" = "200" ]; then
        REMOTE=$(curl -f -s -S -k https://jooni22.github.io/ethoscfg/ciolkowskiego.txt);
        echo $REMOTE > /home/ethos/remote.conf;
    fi
else
    GITHUBLIVE=$(curl -m 5 -s --head  --request GET https://jooni22.github.io/ethoscfg/andersa.txt | grep "200 OK" | cut -d " " -f 2);
    if [ "$GITHUBLIVE" = "200" ]; then
        REMOTE=$(curl -f -s -S -k https://jooni22.github.io/ethoscfg/andersa.txt);
        echo $REMOTE > /home/ethos/remote.conf;
    fi
fi

################################################# CZYSCI FOLDER HOME/ETHOS

CLEAN=$(ls | grep -v "local.conf" | grep -v "custom.sh" | grep -v "remote.conf" | grep -v "sgminer*" | grep -v "Pictures" | grep -v "Desktop" | grep -v "debug.txt" | grep -v "verSCRIPT.txt" | grep -v "customscript.sh" | grep -v "recustom.sh" | grep -v "bashrc.txt" | xargs)
if [ "$CLEAN" != "" ]; then
  rm -f $CLEAN
fi

################################################# CZYSCI LOGI CLAYMORE

MINERLOGS=$(cd /opt/miners/claymore; ls | grep  "log.txt" | xargs);
LOCATION=/opt/miners/claymore/;
if [ "$MINERLOGS" != "" ]; then
  cd $LOCATION;
  rm -f $MINERLOGS;
fi

################################################# SPRAWDZA DATE I WYPISUJE DO PLIKU DO DEBUGOWANIA CZY CUSTOM JEST ODPALANE

CZAS=$(date);
CUSTOM=$(cat /home/ethos/debug.txt | tail -1);
echo "$CUSTOM | $CZAS recustom" | sudo tee /home/ethos/debug.txt

