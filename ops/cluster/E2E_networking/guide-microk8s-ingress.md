# Exposing sercives in the cluster
## Pre-reqs
> Deploy the microk8s nginx based ingress controller and dns.
```
microk8s enable ingress
microk8s enable dns
microk8s enable metallb
```
## Owned by microservice
> The container/pod with webserver. Here a basic nginx
```
kubectl run nginx --image nginx
kubectl expose pod nginx --port 80 --type LoadBalancer

# validate:
kubectl get svc  | grep nginx
curl [cluster-ip]:80
```

> Adding an ingress rule with url-routing / to nginx-plain-http service.
```
kubectl apply -f resources/app-ingress-rule.yaml
```

## Owned by cluster provider
 The ingress-controller itself has to be configured now to enable the passthrough
```
kubectl edit cm -n ingress nginx-ingress-tcp-microk8s-conf
#add:
data:
  "80": default/:80
```
```
kubectl expose -n ingress pod nginx-ingress-microk8s-controller-[hash] --port=80 --target-port=80

kubectl edit svc -n nginx-ingress-microk8s-controller-<hash>
```

```
  ports:
  - nodePort: 30001
    port: 80
    protocol: TCP
    targetPort: 80
...
  type: NodePort
```

Run this and check if there are actual endpoints for the app service and ingress service:
```
NAME                                      ENDPOINTS        AGE
plain-svc                                 10.1.202.83:80   18h
nginx-ingress-microk8s-controller-ssm6k   10.1.202.85:80   17h
```

Run this to check service wiring:
```
kubectl get svc -n ingress
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
plain-svc                                 ClusterIP   10.152.183.218   <none>        80/TCP         18h
nginx-ingress-microk8s-controller-ssm6k   NodePort    10.152.183.89    <none>        80:30001/TCP   17h
```

Access the serivce with:
localhost:30001  -> nodeport svc -> ingress (Level 7 load balancer) -> matching url path / to plain-svc -> svc to pod to container. 