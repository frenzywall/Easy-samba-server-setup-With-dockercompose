#!/bin/bash
IP_ADDRESS=$(hostname -I | awk '{print $1}')


echo "The Samba server can be accessed using the following address:"
echo "smb://$IP_ADDRESS/shared"
