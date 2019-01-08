red=`tput setaf 1`
green=`tput setaf 2`
blue='\033[0;34m'
reset=`tput sgr0`

export PATH=$PATH:/Applications/MAMP/Library/bin/

echo "${green}export data base...${reset}"
php wp-cli.phar db export --add-drop-table dump.sql

echo "${green}deploy on server${reset}"

Make dbdeploy
