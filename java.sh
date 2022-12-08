#!/bin/bash
DONE="\e[0;32m ✔\e[0m"
ERROR="\e[0;31m ✘\e[0m"
YELLOW="\e[1;33m"
LIGHT_RED="\e[1;31m"
LIGHT_GREEN="\e[1;32m"
COLOR_NULL="\e[0m"
PURPLE="\e[0;35m"
CYAN="\e[0;36m"
WHITE="\e[1;37m"
LIGHT_PURPLE="\e[1;35m"

clear

function spigot {
	echo -e "\n"
	echo -e -n "${CYAN} Enter the RAM to be assigned in MB (ex: 512): ${COLOR_NULL}"
	read spigotmem
	echo -e -n "${CYAN} Enter the location of the server folder. (ex: /root/spigot): ${COLOR_NULL}"
	read spigotfolder
	echo -e -n "${YELLOW} Enter the port of the server. (ex: 25565): ${COLOR_NULL}"
	read spigotport
	echo -e "${CYAN} Server type selected: ${YELLOW}Spigot ${COLOR_NULL}"
	SPIGOTTYPE=("Spigot" "Paper" "Vanilla" "Cancel")
	select OPTION in "${SPIGOTTYPE[@]}"; do
		case "$REPLY" in
		1) spigott ;;
		2) paper ;;
		3) vanilla ;;
		4) exit ;;
		*) echo -e "${ERROR} ${LIGHT_RED}The argument you entered is incorrect ${COLOR_NULL}"
		esac
	done
}


## SPIGOT ##
function spigott {
	echo -e "\n"
	mkdir ${spigotfolder:-/root/spigot}
	cd ${spigotfolder:-/root/spigot}
	echo -e "${YELLOW} Setting up the server port...${COLOR_NULL}"
	echo "server-port=${spigotport:-25565}" > server.properties
	echo -e "${YELLOW} The eula file has been created. ${COLOR_NULL}"
	echo "eula=true" > eula.txt
	spigotversion
}

function spigotversion {
  	SPIGOTVERSION=("1.19.2" "1.19.1" "1.19" "1.18.2" "1.18.1" "1.18" "1.17.1" "1.17" "1.16.5" "1.16.4" "1.16.3" "1.16.2" "1.16.1" "1.15.2" "1.15.1" "1.15" "1.14.4" "1.14.3" "1.14.2" "1.14.1" "1.14" "1.13.2" "1.13.1" "1.13" "1.12.2" "1.12.1" "1.12" "1.11" "1.10.2" "1.9.4" "1.9.2" "1.9" "1.8.8" "1.8.3" "1.8" "Cancel")
  		echo -e "${CYAN} Select the server version. ${COLOR_NULL}"
 		select SPIGOTVERSIONSEL in "${SPIGOTVERSION[@]}"; do
 		   case "$REPLY" in
   			1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35) stepsSpigot ;;
   			36) exit ;;
   		*) echo -e "${ERROR} ${LIGHT_RED}The argument you entered is incorrect! ${COLOR_NULL}";;
   		esac
  	done
}

function stepsSpigot {
	echo -e " "
	cd ${spigotfolder:-/root/spigot}
	wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
	compilerSpigot
	starterFileSpigot
}

function compilerSpigot {
	cd ${spigotfolder:-/root/spigot}
	echo -e "${YELLOW} The build of the jar is in progress. . . (it will take a while)${COLOR_NULL}"
	curl -O -J -L https://cdn.azul.com/zulu/bin/zulu17.38.21-ca-jdk17.0.5-linux_x64.tar.gz
	tar -zxvf zulu17.38.21-ca-jdk17.0.5-linux_x64.tar.gz
	"${spigotfolder:-/root/spigot}/Zulu/zulu-17/bin/java" -jar BuildTools.jar --rev ${SPIGOTVERSIONSEL} > /dev/null
	find ./ -type d -not -name spigot-${SPIGOTVERSIONSEL}.jar | xargs rm -r
	find ./ -type f -not -name spigot-${SPIGOTVERSIONSEL}.jar | xargs rm
}

function starterFileSpigot {
	cd ${spigotfolder:-/root/spigot}
	echo -e "${YELLOW} The startup file has been created. ${COLOR_NULL}"
	echo -e ' '
	java -Xms128M -Xmx${spigotmem:-512}M -jar spigot-${SPIGOTVERSIONSEL}.jar nogui >> start.sh 
	chmod +x start.sh 
	successInstallSpigot
}

function successInstallSpigot {
	echo -e " "
  	echo -e "${LIGHT_PURPLE}_/-/_/-/_/-/_/-/_/-/_/-/_/-/_/-/_/-/_/-/_${COLOR_NULL}"
  	echo -e "${LIGHT_GREEN} Your server was successfully installed!\n   ${CYAN}* Version: ${WHITE}Spigot ${SPIGOTVERSIONSEL}\n   ${CYAN}* Location: ${WHITE}${spigotfolder:-/root/spigot}\n   ${CYAN}* RAM: ${WHITE}${spigotmem:-512}M\n   ${CYAN}* Port: ${WHITE}${spigotport:-25565} ${COLOR_NULL}"
  	echo -e "${LIGHT_PURPLE}_/-/_/-/_/-/_/-/_/-/_/-/_/-/_/-/_/-/_/-/_${COLOR_NULL}"
  	echo -e "${YELLOW}To start the server use the ${LIGHT_RED}./starter.sh ${YELLOW}command${COLOR_NULL}"
  	exit
}