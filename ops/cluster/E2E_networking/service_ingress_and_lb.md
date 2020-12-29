## Challenge
It's good practice to expose each pod via service of type clusterId. This enables internal cluster communication for internal interfaces. To enable external requests it is recommended to create an ingress rule which routes a url path to the service. Additionally you'll need any ingress controller and a mechanism to expose the ingtess-controller externally. The easiest way is to expose the ingress controller with a service type load-balancer. Be careful, in cloud environments, this will thell the cluster provides to spin up an actual load-balancer which comes with a fixed cost. But having the ingreess cotroller, which does further routing, you'll only need one loadbalancer. 
On bare metal, you won't have this automatism per default. You have to install a lb provisioner like metallb or klipper-lb.

In this guide i'll document all steps needed to expose a simple nginx container all the way out of the cluster. (plain http only)

## Pre-reqs

```
sudo apt install net-tools
microk8s enable ingress
microk8s enable dns
microk8s enable metallb      # enter an ip range which can be given to load balancers.
```
## Exposing the microservice
> The container/pod with webserver. Here a basic nginx
```
kubectl run nginx --image nginx
kubectl expose pod nginx --port 80 --type ClusterIP
```

> Adding an ingress rule with url-routing / to nginx-plain-http service.
```
kubectl create ingress nginx --rule=/=nginx:80
```

## Exposing the ingress controller
```
The microk8s nginx ingress comes as daemonset. You cannot expose it, so you'll have to use the pod.

# Here is the magic done which spins up the service plus the load balancer (either in the cloud or by metallb)

kubectl expose -n ingress pod nginx-ingress-microk8s-controller-<hash> --port=80 --target-port=80 --type LoadBalancer
```

> if metallb did it's job correctly, you'll see an EXTERNAL-IP on the ingress service:

```
kubectl get svc -n ingress
NAME                                      TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)        AGE
nginx-ingress-microk8s-controller-d5h47   LoadBalancer   10.152.183.133   10.64.140.43   80:31901/TCP   15s
```

Now you should be able to reach the nginx homepage on your host system under: 
```
<ip of virtual eth0>:<NodePort of loadbalancer service>
```

The virtual interface if WSL2 is not reachable from your home network. You have to create a proxy on you host system 
```
netsh interface portproxy add v4tov4 listenport=[some port] listenaddress=0.0.0.0 connectport=[Node Port] connectaddress=[wsl eth0]
```

> I created a script that exposes all nodeports on the host's netadress with starting with port 17000. Check wsl-port-proxies.ps1.  

> Keep in mind to create exceptions in you firewall. E.g. an rule for port range 17000-17005 in Windows Defender Firewall.