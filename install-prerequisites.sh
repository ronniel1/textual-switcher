#!/bin/bash

# Determine package manager
YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)
if [[ ! -z $YUM_CMD ]]; then
PKG_MGR_CMD="sudo yum install -y"
elif [[ ! -z $APT_GET_CMD ]]; then
PKG_MGR_CMD="sudo apt install -y"
else
	echo "Error: Package manager was not found."
	exit 1;
fi

${PKG_MGR_CMD} x11-utils
${PKG_MGR_CMD} wmctrl

