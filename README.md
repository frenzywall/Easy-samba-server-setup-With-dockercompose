# Samba Server Setup and Access Guide

## Overview

How to use!

For linux systems: Simply run the script in User_scripts to get your host Ip address.

Create a folder in this directory structure : /home/{your_root_home_folder}/shared. You can change this directory and name to your liking but this would mean you have to change the shared volume in docker container. To keep it simple, try to create a folder as instructed above.

## Linux Systems

1. **Run the Script**  
   Execute the script located in `User_scripts` to obtain your host IP address.

2. **Create a Shared Folder**  
   Create a folder with the following directory structure:  
   `/home/{your_root_home_folder}/shared`  
   You can change the directory and name to your liking, but this will require updating the shared volume path in the Docker container. For simplicity, create the folder as instructed above.

## Windows Users

1. **Create a Shared Folder**  
   Create a folder in a directory you want to sync. For example:  
   `c:/shared`

2. **Update Docker Compose File**  
   In your `docker-compose.yml` file, modify the following line:  
   ```yaml
   - /home/frenzy/shared:/srv/samba/shared
# Samba Server Access Guide

## Connecting to Samba Server

Follow these steps based on the operating system you are using to connect to your Samba server:

### Connect to Samba from Windows

1. Open File Explorer.
2. In the address bar, type:  
   `\\<Samba-server-IP-address>\Shared`  
   For example:  
   `\\192.168.1.100\Shared`
3. Press Enter.
4. Enter the following credentials:
   - **Username:** guest
   - **Password:** Leave it blank (if configured to allow guest access with no password).
5. You should now be able to access the shared folder.

### Connect to Samba from Linux

1. Open File Manager (e.g., Nautilus).
2. In the location bar, type:  
   `smb://<Samba-server-IP-address>/Shared`  
   For example:  
   `smb://192.168.1.100/Shared`
3. Press Enter.
4. Provide the following credentials:
   - **Username:** guest
   - **Password:** Leave it blank (for guest access).
5. The shared folder should now be accessible.

### Connect to Samba from Android

1. Open a file manager app like CX File Explorer.
2. Go to the Network tab and add a new SMB connection.
3. In the Host field, enter:  
   `smb://<Samba-server-IP-address>/Shared`  
   Example:  
   `smb://192.168.1.100/Shared`
4. Enter the following details:
   - **Username:** guest
   - **Password:** Leave it blank (if using guest access).
5. You should be able to access the shared folder.

### Connect to Samba from macOS

1. Open Finder.
2. Press `Cmd + K` to open the "Connect to Server" window.
3. Type:  
   `smb://<Samba-server-IP-address>/Shared`  
   For example:  
   `smb://192.168.1.100/Shared`
4. Click Connect.
5. Enter the following credentials:
   - **Username:** guest
   - **Password:** Leave it blank (for guest access).
6. The Samba share should now be mounted.

## Note!

- **IP Address:** Replace `<Samba-server-IP-address>` with the host machine's IP address where the Samba server is running. You can find this IP using `ifconfig` or `ip addr` commands on Linux or your Docker host.
- **Folder Name:** The share is named `Shared`, so use this share name in the connection URL.
- If the `nmbd` service is running, Windows devices might automatically discover the Samba server in the network section.
