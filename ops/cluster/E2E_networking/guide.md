microk8s enable ingress

kubectl edit -n ingress cm nginx-ingress-tcp-microk8s-conf add:  
```
data:
  "443": default/home:443
```

kubectl apply -f resources

kubectl expose -n ingress pod nginx-ingress-microk8s-controller-ssm6k --port=80 --target-port=80

kubectl edit svc -n nginx-ingress-microk8s-controller-<hash>  

can't remember what I changed and rollout history is not supported on service :( but this is needed:
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