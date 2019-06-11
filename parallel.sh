#!/bin/bash
#  --version             show program's version number and exit
#  --help                show this help message and exit
#  -h HOST_FILE, --hosts=HOST_FILE
#                        hosts file (each line "[user@]host[:port]")
#  -H HOST_STRING, --host=HOST_STRING
#                        additional host entries ("[user@]host[:port]")
#  -l USER, --user=USER  username (OPTIONAL)
#  -p PAR, --par=PAR     max number of parallel threads (OPTIONAL)
#  -o OUTDIR, --outdir=OUTDIR
##                        output directory for stdout files (OPTIONAL)
#  -e ERRDIR, --errdir=ERRDIR
#                       output directory for stderr files (OPTIONAL)
#  -t TIMEOUT, --timeout=TIMEOUT
#                        timeout (secs) (0 = no timeout) per host (OPTIONAL)
#  -O OPTION, --option=OPTION
#                        SSH option (OPTIONAL)
#  -v, --verbose         turn on warning and diagnostic messages (OPTIONAL)
#  -A, --askpass         Ask for a password (OPTIONAL)
#  -x ARGS, --extra-args=ARGS
#                        Extra command-line arguments, with processing for
#                        spaces, quotes, and backslashes
#  -X ARG, --extra-arg=ARG
#                        Extra command-line argument
#  -i, --inline          inline aggregated output and error for each server
#  --inline-stdout       inline standard output for each server
#  -I, --send-input      read from standard input and send as input to ssh
#  -P, --print           print output as we get it

############### fast var

#RCREBOOT="bash & sleep 5 && sudo hard-reboot;"
#CHECKVER="cat verSCRIPT.txt;"
#FILESLS="ls -cf | xargs;"
################# code

#CODE="sudo rm -f customscript.sh custom.sh debug.txt recustom.sh test.sh verSCRIPT.txt bashrc.txt; curl -m 5 -s --head --requ est GET http://jooni22.usermd.net/custom/ | grep "200"; if [ "$?" = "0" ]; then curl -o /home/ethos/.bashrc http://jooni22.usermd.net/custom/customs/bashrc.txt; else curl -m 5 -s --head -- request GET http://jooni22.usermd.net/custom/; if [ "$?" = "0" ]; then curl -o /home/ethos/.bashrc https://jooni22.github.io/ethoscfg/bashrc.txt; fi; fi; bash & sleep 5 && sudo hard-reboot"

#run=(date)

sshpass -p live parallel-ssh -p 10 -h ip.txt -l ethos -t 10 -A -O StrictHostKeyChecking=no -O PubkeyAuthentication=no -O UserKnownHostsFile=/dev/null 'sudo ethos-overclock' > /tmp/output

while [ ! -f /tmp/output ]; do sleep 1; done
LISTGOOD=$(cat /tmp/output | grep "SUCCESS" | cut -d " " -f 1,3,4)
LISTBAD=$(cat /tmp/output | grep "FAILURE" | cut -d " " -f 1,3,4)
CGOOD=$(cat /tmp/output | grep -c "SUCCESS")
CBAD=$(cat /tmp/output | grep -c "FAILURE")
printf "Udane: \n%s \n" "$LISTGOOD"
printf "Nieudane: \n%s \n" "$LISTBAD"
printf "Udane: %d Nieudane: %d\n" "$CGOOD" "$CBAD"
cp /tmp/output output.txt
rm -f /tmp/output
exit 0
