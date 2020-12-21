# December 20th

## Today I learned...  
1. WSL2 uses it's own init as PID1, no systemd -> no snap -> no microk8s :(
2. My router does not support IPv4 port forwarding anymore :(  
3. doublespace for linebreak in .md :)  
 
## What this project is and where it should go
As by the initial name, it is a playground repo for all the things realted to kubernetes. I intend to log and share my hands on experiences in the journal directory.

# First steps
## Clusters and how to reach them
At the time of kubecon EU 2020 there were over 99 kubernetes distros out there. The first decision is what to used and where to deploy. Installing the cluster can be a mess, but as for me any cluster will do, I chose the zero ops microk8s. Well, not so zero ops with my dev setup see TIL 1. :D  
For now I don't like any fixed cost solution with a cluster in the cloud, so my first challenge is to check what I can do on bare metal. My first attempt to a running cluster is with WSL2, as I'm not running a native Linux on my home machine for several reasons.
The WSL2 usage is more seamless than a VM and I did not have much experiences with it, since some failed attempts with docker on WSL version 1 a while ago. I found [this][2] talk about how easy it is to run a cluster on WSL2 to I gave it a shot. Well, you might end up in the same rabbit hole as I did, because you have to apply hack arounds in order to use systemd. Here is the related [issue / pid 1 discussions][3] and somewhere deep down in the tread the [solutions][4] and [this][5] and [this][6]. In the end I got it running after some attempts with [this][6], but it was way more effort that spinning up a VM.  

## Networking
My next goal was to reach some webserver from my host machine browser. There are quite some steps on the way, to do this properly. Due to the networking complexity I did this with plain http services. First I enabled the microk8s ingress and exposed it. Then I deployed some basic nginx deployments with service, ingress rule and ingress config. This all went pretty well, having prior knowledge with k8s resources and kubectl commands.
The last cluster-level step was to make the ignress available from the outside. I simply edited the ingress service to be a node port, wich is also listening on the host. Here's a more elaborate [explanation][7]. Finally I was able to see the nginx welcome page in my browser :).  
In the end I tried to port forward the ingress nodeport in my router. Sadly this failed, because IPv4 port forwarding is not supported anymore. I did some research to solve the 6to4 problem and found [this][8]. Best solution would be to host everything with IPv6 natively, but docker and k8s (dual-stack) IPv6 features are still alpha/beta and require [additional operations][9]. So next best is 6to4 reverse-proxy. 
Doing some IPv6 stuff will be  

[1]: https://www.youtube.com/watch?v=RyXL1zOa8Bw&ab_channel=CNCF%5BCloudNativeComputingFoundation%5D
[2]: https://ubuntu.com/blog/kubernetes-on-windows-with-microk8s-and-wsl-2 "microk8s in WSL2"
[3]: https://github.com/microsoft/WSL/issues/994
[4]: https://github.com/microsoft/WSL/issues/994#issuecomment-618746300
[5]: https://github.com/microsoft/WSL/issues/994#issuecomment-622979502
[6]: https://gitlab.com/relief-melone/wsl-initial-setup/-/blob/master/README.md
[7]: https://kubernetes.github.io/ingress-nginx/deploy/baremetal/
[8]: https://www.internetsociety.org/resources/deploy360/2013/making-content-available-over-ipv6/#:~:text=IPv6%2Dto%2DIPv4%20proxy,the%20network%20can%20support%20IPv6.
[9]: https://stephank.nl/p/2017-06-05-ipv6-on-production-docker.html