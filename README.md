# playground
A playground for all the kubernetes things


# Guide round this repo

```
playground/
├── LICENSE
├── README.md
├── journal                                    <- an actual journal where i write down enlightments, learnings, etc.
│   └── december-2020.md
└── ops
    ├── cluster
    │   ├── E2E_networking
    │   │   └── guide-microk8s-ingress.md      <- how to expose a container using svc, ingress and a loadbalancer (0 yaml guide)
    │   └── microk8s_with_kubectl.sh
    └── wsl
        └── setup_systemd_and_microk8s.md      <- how to spin up a microk8s cluster in wsl2
```