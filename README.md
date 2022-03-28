# Installation

This project is using [Multipass](https://multipass.run) to run local kubernetes with [Microk8s](https://microk8s.io)


## Services

Services | Command
---------|----------
 Traefik | `make traefik`
 Maria DB | `make mariadb`
 Redis | `make redis`
 Longhorn | `make longhorn`

Make sure to add all used domain name to `/etc/hosts` with master domain name like this:

`10.200.211.12 k8s-master traefik.k8s.com k8s.com frontend.k8s.com backend.k8s.com`
## Tools to install to be comfortable with k8s manipulation

* kustomize
* kubectl
* kubectx
* kubens
* k9s
* lens
* multipass
* krew

## Useful links

- [kubectx & kubens](https://blog.zwindler.fr/2018/08/28/utiliser-kubectx-kubens-pour-changer-facilement-de-context-et-de-namespace-dans-kubernetes/)
- [Script Shell Tuto](https://doc.ubuntu-fr.org/tutoriel/script_shell)
- [Krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
- [Test k8s online](https://labs.play-with-k8s.com)
- [Artifact Hub](https://artifacthub.io/)
- [MetalLB & Traefik](https://www.devtech101.com/2019/03/02/using-traefik-as-your-ingress-controller-combined-with-metallb-on-your-bare-metal-kubernetes-cluster-part-2/)

## Troubleshooting

Links
- [Longhorn & Multipass](https://artsysops.com/2021/10/31/how-to-make-rancher-longhorn-work-with-microk8s/)

Commands

```shell
kubectl delete all --all -n monitoring
```
