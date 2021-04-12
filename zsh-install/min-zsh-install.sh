#!/usr/bin/sh

# exit when any command fails
set -e

# if git is not found, script halts
which git

#install zsh
if [ -f /bin/apt ]
then
    sudo apt install zsh
elif [ -f /bin/dnf ]
then
    sudo dnf install util-linux-user zsh
elif [ -f /bin/pacman ]
then
    sudo pacman -S zsh
else
    echo "Couldn't determine the package manager, aborting..."
    exit 1
fi

if ! chsh -s $(which zsh);
then
    echo "chsh command unsuccessful. Change your default shell manually."
fi

#install oh-my-zsh, note, the "unattended" sets chsh and runzsh during
#oh-my-zsh installation to NO
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# download pure
git clone https://github.com/sindresorhus/pure.git ~/.oh-my-zsh/custom/themes/pure

# download zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# /plugins(/ - search for line with pattern "plugins("
# /s/search/replace/
# .$ - the $ is last character, . is any line
sed -i '/plugins=(/s/.$/ rsync zsh-autosuggestions)/' ~/.zshrc

# comment out the default theme, not really necessary
sed -i '/ZSH_THEME/ s/^/#/' ~/.zshrc

cat <<EOT >> ~/.zshrc

# PURE PROMPT INSTALLATION:
fpath+=~/.oh-my-zsh/custom/themes/pure

autoload -U promptinit; promptinit

zmodload zsh/nearcolor
zstyle :prompt:pure:virtualenv color '#00acee'
zstyle :prompt:pure:path color yellow

prompt pure

# using cheat <cmd>
cheat() {
    curl cheat.sh/$1
}
EOT

# since we are still in bash
zsh -c "source ~/.zshrc"

printf "\nYou can now close the session and open again, or try restarting your device (in case of Fedora)\n"
