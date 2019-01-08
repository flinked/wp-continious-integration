red=`tput setaf 1`
green=`tput setaf 2`
blue='\033[0;34m'
reset=`tput sgr0`

export PATH=$PATH:/Applications/MAMP/Library/bin/

echo "${green}import data base...${reset}"
php wp-cli.phar db import dump.sql

echo "${green}replace...${reset}"

php wp-cli.phar db query < update.sql

echo "${red}remove dump${reset}"
rm dump.sql