#!/bin/bash

cecho () {
    declare -A colors;
    colors=(\
        ['black']='\E[0;47m'\
        ['red']='\E[0;31m'\
        ['green']='\E[0;32m'\
        ['yellow']='\E[0;33m'\
        ['blue']='\E[0;34m'\
        ['magenta']='\E[0;35m'\
        ['cyan']='\E[0;36m'\
        ['white']='\E[0;37m'\
    );

    local defaultMSG="No message passed.";
    local defaultColor="black";
    local defaultNewLine=true;

    while [[ $# -gt 1 ]];
    do
    key="$1";

    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
        -n|--noline)
            newLine=false;
        ;;
        *)
            # unknown option
        ;;
    esac
    shift;
    done

    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
    newLine=${newLine:-$defaultNewLine};

    echo -en "${colors[$color]}";
    echo -en "$message";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0; #  Reset text attributes to normal without clearing screen.

}
### Colors ##
ESC=$(printf '\033') RESET="${ESC}[0m" BLACK="${ESC}[30m" RED="${ESC}[31m"
GREEN="${ESC}[32m" YELLOW="${ESC}[33m" BLUE="${ESC}[34m" MAGENTA="${ESC}[35m"
CYAN="$ESC[36m" WHITE="${ESC}[37m" DEFAULT="${ESC}[39m"
cyanprint() { printf "${CYAN}%s${RESET}\n" "$1"; }
_process() {
  echo -e "\n"
  cyanprint " → $@"
}
_success() {
  printf "\n%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $1"
}

cecho -c 'blue' "***************************************"
cecho -c 'blue' "Welcome to the RPi Dashboard installer!"
cecho -c 'blue' "***************************************"
if ! command -v git >/dev/null; then
    echo "${RED}Git is not installed. Please install Git to continue.${RESET}"
    exit 1
fi

# auto Install lighttpd if not already installed 
if ! command -v lighttpd >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y lighttpd
    sudo lighttpd-enable-mod fastcgi fastcgi-php
    sudo service lighttpd force-reload
fi


hostn="`hostname`"
cecho -c 'blue' "This setup will install the RPi Dashboard to -> /var/www/html/"
_process "Please choose a subfolder name. This name will be part of the address http://$hostn/{your_subfolder_name} with which you can access your RPi dashboard within your local network."

subfoldern=""
while [[ -z "$subfoldern" ]]; do
    read -p "Enter custom subfolder name: " subfoldern
    subfoldern=$(echo $subfoldern | xargs)
    if [[ -z "$subfoldern" ]]; then
        echo "${RED}Please enter a valid subfolder name.${RESET}"
    fi
done
_process "Creating subfolder /var/www/html/$subfoldern ..."
sudo groupadd -f www-data
sudo usermod -a -G www-data www-data
sudo usermod -a -G www-data "$USER"

sudo chown -R "$USER":www-data /var/www/html
sudo chmod -R 755 /var/www/html


mkdir -p /var/www/html/$subfoldern
# Check if mkdir succeeded
if [ $? -ne 0 ]; then
    echo
    echo "${RED}Failed to create sub-directory for the RPi Dashboard!${RESET}"
    echo "${YELLOW}Please make sure that the folder /var/www/html/ exists (if not, make sure a web server is installed first) and that you have necessary permissions to write into that folder.${RESET}"
    exit 1
fi

# Cloning repository into the subfolder
_process "Cloning repository into /var/www/html/$subfoldern ..."
sudo git clone https://github.com/northvector/Raspberry-Pi-dashUI /var/www/html/$subfoldern
if [[ $? -ne 0 ]]; then
    echo "${RED}Failed to clone repository. Check your permissions and network connection.${RESET}"
    exit 1
fi
_process "Repository cloned successfully."

_process "Setting up valid permissions for /var/www/html/$subfoldern ..."
chown -R ${whoami}:www-data /var/www/html/$subfoldern
chmod -R 775 /var/www/html/$subfoldern

_success "Installation done! To access the newly installed RPi dashboard open up a web browser and access URL: http://$hostn/$subfoldern !"
_process "Please report any issues here: https://github.com/femto-code/Raspberry-Pi-Dashboard/issues. Thank you!"
