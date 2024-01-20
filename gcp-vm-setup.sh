# don't allow password login
sudo sed -i 's/PermitRootLogin no/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config

# create authorized_keys file
sudo mkdir /root/.ssh
sudo chmod 700 /root/.ssh
sudo touch /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys

# add my public key to authorized_keys
sudo echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXdAzn53i+OygyKItq8TF4GSW0cS7g24cOHVKEkuR4Z brijesh@wawdhane.com" >> /root/.ssh/authorized_keys

# install zsh
# sudo apt update
sudo apt install zsh

# make zsh the default shell
sudo chsh -s $(which zsh)

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

source ~/.zshrc

# restart sshd
sudo systemctl restart sshd
