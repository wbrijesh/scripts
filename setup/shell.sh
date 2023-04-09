#!/usr/bin/env bash

# Steps:
# 1. Update package list
# 2. Install zsh
# 3. Make zsh the default shell
# 4. Install oh-my-zsh
# 5. Install powerlevel10k theme
# 6. Set powerlevel10k as the default theme
# 7. Apply changes from .zshrc
# 8. Configure powerlevel10k

# 1. Update package list
sudo apt update

# 2. Install zsh
sudo apt install zsh

# 3. Make zsh the default shell
chsh -s $(which zsh)

# 4. Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 5. Install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 6. Set powerlevel10k as the default theme
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

# 7. Apply changes from .zshrc
source ~/.zshrc

# 8. Configure powerlevel10k
p10k configure
