# playground
A playground for all the kubernetes things


# Guide round this repo

Reading order:
1. setup_systemd_and_microk8s.md
1. service_ingress_and_lb.md

```
playground/
├── LICENSE
├── README.md
└── ops
    ├── cluster
    │   ├── E2E_networking
    │   │   └── service_ingress_and_lb.md      <- how to expose a container using svc, ingress and a loadbalancer (the 0 yaml guide)
    │   └── microk8s_with_kubectl.sh
    └── wsl
        └── setup_systemd_and_microk8s.md      <- how to spin up a microk8s cluster in wsl2
```