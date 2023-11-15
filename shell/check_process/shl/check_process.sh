#!/bin/bash

###########################################################
# Script: Vérification d'etat de service et lancement si KO
###########################################################

#*** CONFIG ***

function usage {
	echo -e "\nCe script est a lancer avec un seul parametre ou sans parametre"
	echo -e "\nUsage: ./check_process.sh [argument] \n"
}

#Vérification de nombre de parametre

if [ $# -gt 1 ]
then
	usage 
	exit 1
fi

#Chargement du script dinitialisation 

source init_check_process.sh

#*** Déclaration de fonctions

function supervision_process {
	local OUTPUT=$(ps aux | grep -v grep | grep $1 | wc -l)
	if [ "$OUTPUT" -gt 0 ]
	then
		#Serveur en cours d'exécution ..."
		echo "$(date '+%d-%m-%Y %H:%M:%S') > check_process [INFO] : Le processus ($1) est en cours d execution..." | tee -a $LOG_FILE
	else
		echo "$(date '+%d-%m-%Y %H:%M:%S') >  check_process [INFO] : Le processus ($1) n est pas démarré" | tee -a $LOG_FILE
		echo "$(date '+%d-%m-%Y %H:%M:%S') >  check_process [INFO] : Demarrage du processus ... ($1)" | tee -a $LOG_FILE
		local rep=$2
		local script=$3
		sudo $rep/$script 2>&1 | tee -a $LOG_FILE
	fi
}

#***Demarrage de traitement

echo "$(date '+%d-%m-%Y %H:%M:%S') > check_process [INFO] : ######### Demarrage de traitement ...  ###########" | tee -a $LOG_FILE

while read ligne
do
	#Sauter les lignes vides ou commentées
	echo "$ligne" | grep -E "^$" >>/dev/null && continue 
	echo "$ligne" | grep -E "^#" >>/dev/null && continue
	REP=$(echo "$ligne" | cut -d ";" -f1)
	SCRIPT=$(echo "$ligne" | cut -d ";" -f2)
	PROCESSUS=$(echo "$ligne" | cut -d ";" -f3)
	supervision_process ${PROCESSUS} ${REP} ${SCRIPT}
done < "$FIC_PARAM"

echo "$(date '+%d-%m-%Y %H:%M:%S') > check_process [INFO] : ######### Fin de traitement ###########" | tee -a $LOG_FILE
exit
