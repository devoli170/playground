This is basically [this setup][1] tailored to my system.  
## Disclaimer
 I did not check the scripts for any malicios parts, which is pretty bad regarding the level of control the install script has. E.g. the host drives via mounts... :(

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

> Open another terminal. This time you don't need to run as admin. Then set WSL 2 as default
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

## Ubuntu setup
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
> Execute the script again as the newly created user and install your additional software. I disabled nodejs and ssh-server.
```
# Inside of WSL
### copy pasta for S drive  ###
wsl -d ubuntu --user ops sudo /bin/bash /mnt/s/wsl/source/wsl-initial-setup/install.sh

### copy pasta for C drive  ###
wsl -d ubuntu --user ops sudo /bin/bash /mnt/c/wsl/source/wsl-initial-setup/install.sh
```
> Starting the wsl bash
```
wsl -d ubuntu --user ops
```
## More usefull stuff:
> Use internal kubectl to access the cluster, instead of microk8s.kubectl
```
mkdir $HOME/.kube
microk8s config > ~/.kube/config
```
> add bash comletion (one time only)
```
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'source <(helm completion bash)' >> ~/.bashrc
source ~/.bashrc
```

With this you have a running cluster inside your WSL :). Have fun!

-> TODO check if image file in ubuntu folder is usable as snapshot.



[1]: https://gitlab.com/relief-melone/wsl-initial-setup/-/tree/master
[2]: https://docs.microsoft.com/en-us/windows/wsl/install-win10
[3]: https://docs.microsoft.com/en-us/windows/wsl/install-win10#requirements