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


## GPG Keys
```shell
gpg --full-generate-key # DSA et Elgamal (ci.fake@email.com)
gpg --list-secret-keys --keyid-format LONG ci.fake.email.com
gpg --list-secret-keys
kubesec encrypt --key=pgp:C0DF4410B95BF73B7FDF10FC6FD0220606DDCD6E secret.yaml > secret.enc.yaml
kubesec introspect secret.enc.yaml
# PGP fingerprint(s)
C0DF4410B95BF73B7FDF10FC6FD0220606DDCD6E second-key-for-encrypt (just another key) <ci.second.email.com@private>
8475955B10FB59A49A148DB0F6F8FD497DD78630 local-cluster-kubesec <kabaconde15@gmail.com>

gpg --export-secret-key --armor > ci.fake.email.com.private
gpg --armor --export [key-id]
gpg --import $PGP_PRIVATE_KEY
```

## Troubleshooting

- [Longhorn & Multipass](https://artsysops.com/2021/10/31/how-to-make-rancher-longhorn-work-with-microk8s/)

## Useful links

- [Kubesec](https://github.com/shyiko/kubesec)
- [Kubesec & Gitlab CI](https://blog.stack-labs.com/code/keep-your-kubernetes-secrets-in-git-with-kubesec/)
- [Export & Import](https://linuxhint.com/export-import-keys-with-gpg/)
- [Why to use GPG with Git](https://www.synbioz.com/blog/tech/signer-nos-commits)
- [Terminating namespaces 1](https://craignewtondev.medium.com/how-to-fix-kubernetes-namespace-deleting-stuck-in-terminating-state-5ed75792647e)
- [Terminating namespaces 2](https://stackoverflow.com/questions/35453792/pods-stuck-in-terminating-status)

## Usefull commands

```shell
kubectl delete all --all -n monitoring
kubectl version --short
kubectl get nodes -o wide
ipcalc 10.200.211.1/24
```
