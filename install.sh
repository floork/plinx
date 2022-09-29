#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

logo () {
    echo -ne "

        ███╗   ███╗██╗   ██╗██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
        ████╗ ████║╚██╗ ██╔╝██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
        ██╔████╔██║ ╚████╔╝ ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
        ██║╚██╔╝██║  ╚██╔╝  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
        ██║ ╚═╝ ██║   ██║   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
        ╚═╝     ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝

        --------------------------------------------------------------------------
                        Welcome to my Post-Install Script
        --------------------------------------------------------------------------
    "
}

sys (){
    if [ -x "$(command -v pacman)" ];then
        yay -Syu
        bash ${SCRIPT_DIR}/scripts/arch.sh
        elif [ -x "$(command -v dnf)" ];then
        sudo dnf -y upgrade --refresh
        bash ${SCRIPT_DIR}/scripts/fedora.sh
        elif [ -x "$(command -v apt-get)" ];then
        sudo apt-get -y update && sudo apt-get -y upgrade
        bash ${SCRIPT_DIR}/scripts/debian.sh
    else
        echo 'This Distro is not supported!'
    fi
}

fonts(){
    FONT_INSTALLED=$(fc-list | grep -i "Meslo");
    if ! [ "$FONT_INSTALLED" ]; then
        sudo curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
        |   grep "Meslo.zip" \
        |   cut -d : -f 2,3 \
        |   tr -d \" \
        |   wget -qi -
        sudo -s unzip Meslo.zip -d /usr/share/fonts
        # Reloading Font
        fc-cache -vf
        rm ./Meslo.zip
    else
        :
    fi
    FONT_INSTALLED=$(fc-list | grep -i "Fira Code");
    if ! [ "$FONT_INSTALLED" ]; then
        sudo -s curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
        |   grep "FiraCode.zip" \
        |   cut -d : -f 2,3 \
        |   tr -d \" \
        |   wget -qi -
        sudo unzip FiraCode.zip -d /usr/share/fonts
        # Reloading Font
        fc-cache -vf
        rm ./FiraCode.zip
    else
        :
    fi
}

cursor(){
    echo -ne "
       Do you want to use the future-black-cursor?
    "
    echo -ne "
       1) Yes
       0) No
    Choose an option: "
    read -r answer
    case ${answer} in
        1)
            sudo cp -r ${SCRIPT_DIR}/configs/Future-black-cursors /usr/share/icons
            echo '[Icon Theme]' | sudo tee /usr/share/icons/default/index.theme
            echo 'Inherits=Future-black Cursors' | sudo tee -a /usr/share/icons/default/index.theme
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            cursor
        ;;
    esac
}

shell(){
    curl -sS https://starship.rs/install.sh | sh
    git clone https://github.com/floork/my_shell
    cd my_shell
    bash "install.sh"
    cd $SCRIPT_DIR
    clear
}

logo2(){
    echo -ne "

            ███╗   ███╗██╗   ██╗██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
            ████╗ ████║╚██╗ ██╔╝██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
            ██╔████╔██║ ╚████╔╝ ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
            ██║╚██╔╝██║  ╚██╔╝  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
            ██║ ╚═╝ ██║   ██║   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
            ╚═╝     ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
            -------------------------------------------------------------------------

                                            Finished!!

            -------------------------------------------------------------------------
    "
}

del(){
    echo -ne "
    Do you want to delete this script?"
    echo -ne "
        1) Yes, delete and reboot
        2) Only delete
        3) Only reboot
        0) No
    Choose an option:  "
    read -r delt
    case ${delt} in
        1)
            rm -r ${SCRIPT_DIR}
            echo "Your System will Reboot in 5 seconds"
            sleep 5s
            sudo reboot -h now
        ;;
        2)
            rm -r ${SCRIPT_DIR}
        ;;
        3)
            echo "Your System will Reboot in 5 seconds"
            sleep 5s
            sudo reboot -h now
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            del
        ;;
    esac
}

export SCRIPT_DIR

logo
sys
fonts
cursor
shell
logo2
del
