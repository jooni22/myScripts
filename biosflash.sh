#!/bin/bash
sudo wget http://jooni22.usermd.net/custom/pliki/gpu-info -O /opt/ethos/sbin/gpu-info >/dev/null 2>&1 
if ! [ -f "/var/run/ethos/atiflash.file" ]; then
    sudo /opt/ethos/sbin/gpu-info
fi
    removeBios=$(ls | grep ".rom" | xargs); 
    if [ -z "$removeBios" ]; then 
        echo "No bioses in /home/ethos";
    else 
        sudo rm /home/ethos/$removeBios 
        echo "Old Bios $removeBios removed from /home/ethos"; 
    fi 
j=0
i=1

for i in 1 2 3 4 5
do
    strapcopy=$(head -n $i /var/run/ethos/atiflash.file | tail -1 | grep "StrapCopy"); 
    if [ -z "$strapcopy" ]; then
       disallow
       mem=$(head -n $i /var/run/ethos/meminfo.file | tail -1 | cut -d":" -f4,5 | tr ' ' '_' | tr ':' '_');
        if ! [ -f "/home/ethos/$mem.rom" ]; then
            sudo wget http://jooni22.usermd.net/custom/rom/$mem.rom -O /home/ethos/$mem.rom >/dev/null 2>&1;
            ls | grep "$mem.rom"
        fi
       sudo atiflash -p $j /home/ethos/$mem.rom 
     else
       echo 'GPU: '.$j.' already flashed.';
          fi
     j=$((j+1));
done;
/usr/bin/sudo /opt/ethos/sbin/gpu-info;
allow
/usr/bin/sudo /sbin/reboot;
exit 0
exit 0
