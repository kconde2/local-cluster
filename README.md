# Installation

This project is using [Multipass](https://multipass.run) to run local kubernetes with [Microk8s](https://microk8s.io)


## Services

Make sure to add all used domain name to `/etc/hosts` with master's IP like this:

`10.200.211.12 k8s-master traefik.k8s.com k8s.com frontend.k8s.com backend.k8s.com`

Create hosts script uses [hostcl](https://guumaster.github.io/hostctl/)

Services | Command
---------|----------
 MetalLB | `make metallb`
 Traefik | `make traefik`
 Maria DB | `make mariadb`
 Redis | `make redis`
 Longhorn | `make longhorn`

You can run `make common` to run all previous command sequencially.
## Tools to install to be comfortable with k8s manipulation

Use [Arkade](https://github.com/alexellis/arkade) to install all following tools available [here](https://github.com/alexellis/arkade#catalog-of-clis) :

* kustomize
* kubectl
* kubectx
* kubens
* k9s
* lens
* multipass
* krew
* hostcl

## Useful links

- [kubectx & kubens](https://blog.zwindler.fr/2018/08/28/utiliser-kubectx-kubens-pour-changer-facilement-de-context-et-de-namespace-dans-kubernetes/)
- [Script Shell Tuto](https://doc.ubuntu-fr.org/tutoriel/script_shell)
- [Krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
- [Test k8s online](https://labs.play-with-k8s.com)
- [Artifact Hub](https://artifacthub.io/)
- [MetalLB & Traefik](https://www.devtech101.com/2019/03/02/using-traefik-as-your-ingress-controller-combined-with-metallb-on-your-bare-metal-kubernetes-cluster-part-2/)
- [Redis High Availability sentinel](https://severalnines.com/database-blog/redis-high-availability-architecture-sentinel)
- [les sentinelles docker-compose](https://developpeur-freelance.com/les-sentinelles-redis-avec-docker-compose/)

## Troubleshooting

Links
- [Longhorn & Multipass](https://artsysops.com/2021/10/31/how-to-make-rancher-longhorn-work-with-microk8s/)

# Usefull commands

```shell
kubectl delete all --all -n monitoring
kubectl version --short
kubectl get nodes -o wide
ipcalc 10.200.211.1/24
```
