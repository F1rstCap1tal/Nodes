#!/bin/bash

function logo {
  bash <(curl -s https://raw.githubusercontent.com/F1rstCap1tal/Logo/main/logo.sh)
}

function line {
  echo "-----------------------------------------------------------------------------"
}

function colors {
  GREEN="\e[1m\e[32m"
  RED="\e[1m\e[39m"
  NORMAL="\e[0m"
}

function main_tools {
  bash <(curl -s https://raw.githubusercontent.com/F1rstCap1tal/main/main/main.sh)
}

function rust {
  bash <(curl -s https://raw.githubusercontent.com/F1rstCap1tal/rust/main/rust.sh)
  source $HOME/.profile
  cargo install sccache
}

function build_ursa {
  cd $HOME
  git clone https://github.com/fleek-network/ursa.git
  cd ursa
  make install
  source $HOME/.profile
}

function systemd_ursa {
  sudo tee <<EOF >/dev/null /etc/systemd/system/fleek.service
[Unit]
Description=Fleek node
After=network.target

[Service]
User=$USER
ExecStart=/root/.cargo/bin/ursa
WorkingDirectory=$HOME/ursa
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl enable fleek &>/dev/null
  sudo systemctl restart fleek
}

colors
line
logo
line
echo "installing tools...."
line
main_tools
rust
line
echo "clonning repository and build bin files"
line
build_ursa
line
echo "creating systemd file, adding to autostart, starting"
systemd_ursa
echo "installation complete, check logs by command:"
echo "journalctl -n 100 -f -u fleek -o cat"
echo "and wait for -bootstrap complete-"
