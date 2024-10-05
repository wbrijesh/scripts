#!/bin/bash

LATEST_VERSION=$(curl -s https://go.dev/dl/ | grep -oP 'go[0-9.]+\.linux-amd64\.tar\.gz' | head -n 1 | sed 's/\.linux-amd64\.tar\.gz//')

wget https://go.dev/dl/${LATEST_VERSION}.linux-amd64.tar.gz

sudo tar -C /usr/local -xvf ${LATEST_VERSION}.linux-amd64.tar.gz

if ! grep -q "/usr/local/go/bin" ~/.profile; then
  echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.profile
fi

source ~/.profile

rm ${LATEST_VERSION}.linux-amd64.tar.gz

echo "Go has been installed. Run 'source ~/.profile && go version' to verify."
