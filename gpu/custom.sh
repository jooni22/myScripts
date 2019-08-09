#!/bin/bash
# /home/ethos/custom.sh
# This file is where you should put any custom scripting you would like to run.
# It will run once, after Xorg (Graphical interface) starts up, any commands which you absolutely have to run before xorg should be located$
# All scripting in this file should be before the "exit 0" as well.  Preface any commands which require 'root' privileges with the "sudo" c$
# Examples script running as user ethos:
# my_command --my flags
# Example of a php script running as user root:
# sudo php /path/to/my/script.phpzxxxzz

################################################# SPRAWDZA CZY .bashrc ULEGL ZMIANIE

cmp -b bashrc.txt .bashrc
if [ "$?" != "0" ]; then
    cp /home/ethos/bashrc.txt /home/ethos/.bashrc
    bash
fi

################################################# ODPALA recustom.sh W KAŻDYM URUCHOMIENIU KOPARKI

if  [ -f "/home/ethos/recustom.sh" ]; then 
    sudo bash /home/ethos/recustom.sh
fi

################################################# WPISUJE SIE W debug.txt

CZAS=$(date);
CUSTOM=$(cat /home/ethos/debug.txt | tail -1);
echo "$CUSTOM | $CZAS custom" | sudo tee /home/ethos/debug.txt

################################################# SEGREGUJE debug.txt
BASE=$(cat debug.txt | tail -1)
BASECP=$BASE
DBGSCRIPT=$(echo $BASE | tr -s '|' '\n' | grep 'script' | tail -1)
echo "LAST customscript: $DBGSCRIPT" >> /home/ethos/debug.txt
DBGRECUSTOM=$(echo $BASE | tr -s '|' '\n' | grep 'recustom' | tail -1)
echo "LAST recustom: $DBGRECUSTOM" >> /home/ethos/debug.txt
DBGCUSTOM=$(echo $BASE | tr -s '|' '\n' | grep 'custom' | tail -1)
echo "LAST custom: $DBGCUSTOM" >> /home/ethos/debug.txt
echo "$BASECP" >> /home/ethos/debug.txt
exit 0
