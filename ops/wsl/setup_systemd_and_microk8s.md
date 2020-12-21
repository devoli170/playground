This is basically [this setup][1] tailored to my system:


WIN+R -> cmd

## Improtant pre-requisite
```
wsl --set-default-version 2
```

## WSL Installation
I'm working on S: drive. You can replace it with C: or any drive where you'd like to work on.

> Basic dir structure to organize stuff. This will hold the ubuntu image, the WSL persistence, and other source material
```
mkdir s:\wsl\distro
mkdir s:\wsl\source
```
> Get the image:
```
curl https://cloud-images.ubuntu.com/focal/current/
focal-server-cloudimg-amd64-wsl.rootfs.tar.gz --output focal-server.amd64-wsl.tar.gz
```
> Create the sub system with name "ubuntu" and install location s:\wsl\distro\ubuntu
```
wsl --import ubuntu s:\wsl\distro\ubuntu s:\wsl\distro\focal-server.amd64-wsl.tar.gz
```

## Ubuntu setup
> Clone the repo inside wsl to work around windows CR
```
wsl -d ubuntu git clone https://gitlab.com/relief-melone/wsl-initial-setup.git /mnt/s/wsl/source/wsl-initial-setup
```
> Enables systemd when executed for the first time.  You are prompted for a user and pw at the end
```
wsl -d ubuntu /bin/bash /mnt/s/wsl/source/wsl-initial-setup/install.sh
```
> Execute the script again as the newly created user
```
wsl -d ubuntu --user [your-username]
# Inside of WSL
sudo /bin/bash /mnt/s/wsl/source/wsl-initial-setup/install.sh
```




[1]: https://gitlab.com/relief-melone/wsl-initial-setup/-/tree/master