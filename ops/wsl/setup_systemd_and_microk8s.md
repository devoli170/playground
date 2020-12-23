This is basically [this setup][1] tailored to my system.  

## Improtant pre-requisite

Check the official docs: [here][2]. Especially the [requirements][3]. Also this:
```
Please make sure that virtualization is enabled inside of your computer's BIOS. The instructions on how to do this will vary from computer to computer, and will most likely be under CPU related options.
```
 
> Press WIN key and type CMD. right click the app and run as administrator.
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
> Now you have to reboot.  

> After the reboot download this msi with an kernel update and run the .msi: https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

> Open another terminal. This time you don't have to run as admin. Then set WSL version 2 as default
```
wsl --set-default-version 2
```

## Sub System Installation
Change the drive name to wherever you'd like to store your wsl stuff. I'm documenting S and C drives for my convenience. Not going to optimize here.

> Basic dir structure to organize stuff. This will hold the ubuntu image, the WSL persistence, and other source material. 
```
### copy pasta for S drive  ###
mkdir s:\wsl\distro
mkdir s:\wsl\source

### copy pasta for C drive  ###
mkdir c:\wsl\distro
mkdir c:\wsl\source

```
> Get the image:
```
### copy pasta for S drive  ###
curl https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-wsl.rootfs.tar.gz --output s:\wsl\distro\focal-server.amd64-wsl.tar.gz

### copy pasta for C drive  ###
curl https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-wsl.rootfs.tar.gz --output c:\wsl\distro\focal-server.amd64-wsl.tar.gz
```
> Create the sub system with name "ubuntu"
```
### copy pasta for S drive  ###
wsl --import ubuntu s:\wsl\distro\ubuntu s:\wsl\distro\focal-server.amd64-wsl.tar.gz

### copy pasta for C drive  ###
wsl --import ubuntu c:\wsl\distro\ubuntu c:\wsl\distro\focal-server.amd64-wsl.tar.gz
```

## Infra and Cluster setup
> Clone the repo inside wsl to work around windows CR
```
### copy pasta for S drive  ###
wsl -d ubuntu git clone https://gitlab.com/relief-melone/wsl-initial-setup.git /mnt/s/wsl/source/wsl-initial-setup

### copy pasta for C drive  ###
wsl -d ubuntu git clone https://gitlab.com/relief-melone/wsl-initial-setup.git /mnt/c/wsl/source/wsl-initial-setup
```
> Enables systemd when executed for the first time.  You are prompted for a user and pw at the end. I choose the user "ops"
```
### copy pasta for S drive  ###
wsl -d ubuntu /bin/bash /mnt/s/wsl/source/wsl-initial-setup/install.sh

### copy pasta for C drive  ###
wsl -d ubuntu /bin/bash /mnt/c/wsl/source/wsl-initial-setup/install.sh
```
> !!!! restart the ubuntu distro with - If you don't systemd will not run properly. You'll see connection resets from D-Bus and snap not working properly !!!!
```
wsl --shutdown -d ubuntu

### Quick validation before you run the next install stage:
wsl -d ubuntu -u ops

#inside wsl run:
sudo systemctl restart snapd; echo $?

# expected output is 0. If not, try wsl --shutdown -d ubuntu. See [here][4]. If this does not help, try from scratch.
```
> Stay inside the bash where you already confirmed, that systemd is running and execute the script again.  

> In the next stage additional you can choose more stuff to install. There will be 2 prompts. from the first i select all, but i remove nodejs and ssh-server from the second. 
```
# Inside of WSL
### copy pasta for S drive  ###
sudo /bin/bash /mnt/s/wsl/source/wsl-initial-setup/install.sh

### copy pasta for C drive  ###
sudo /bin/bash /mnt/c/wsl/source/wsl-initial-setup/install.sh
```

## More usefull stuff:
> Use internal kubectl to access the cluster, instead of microk8s.kubectl
```
mkdir $HOME/.kube
microk8s config > ~/.kube/config

# remove group-readable warning when sourcing .bashrc
chmod 600 ~/.kube/config
```
> add bash comletion (one time only)
```
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'source <(helm completion bash)' >> ~/.bashrc
source ~/.bashrc
```

With this you have a running cluster inside your WSL :). Have fun!


[1]: https://gitlab.com/relief-melone/wsl-initial-setup/-/tree/master
[2]: https://docs.microsoft.com/en-us/windows/wsl/install-win10
[3]: https://docs.microsoft.com/en-us/windows/wsl/install-win10#requirements
[4]: https://superuser.com/a/1556484/1254574