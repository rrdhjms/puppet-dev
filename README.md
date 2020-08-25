## Requirements

- [Vagrant Reload plugin](https://github.com/aidanns/vagrant-reload)
- Check IP addresses don't clash.
  - If changing the IP address of the NFS server, be sure to reflect these changes in the `PV.yml` file on the Jenkins server.
  - If changing any other IP ensure you update the `Prometheus.yml` file.
  - Update the puppet master IP at `/etc/hosts`.

## Installation Order

The most important part here is that the Puppet Master is installed first. The rest is not too important.

1. Puppetmaster
2. NFS Server
3. Jenkins
4. Jenkins Worker(s)
5. Nexus
6. Logger

## Puppet Master

##### Important commands

On Master

- List all certificates: `puppetserver ca list --all`
- Sign specific certificate: `puppetserver ca sign --certname [name of server]`
- Revoke certificate: `puppetserver ca revoke --certname [name of server]`
- Clean all info related to certificate (good if certificate is revoked and want to resign it) `puppetserver ca clean --certname [name of server]`

On agents:

- Test connection and force pull manfiests: `puppet agent --test`

## Jenkins

#### Get Initial Password

To get initial password either connect to the NFS-Server and navigate to:

```
/srv/nfs/jenkins/secrets/initialAdminPassword
```

## Nexus

#### Get Initial Password

Connect to the VM and naviate to

```
/var/lib/docker/volumes/nexus-data/_data/admin.password
```

## Grafana

#### Default login

`Username: admin`

`Password: admin`

Add Prometheus as a data source - do not use localhost even though Prometheus and Grafana are on the same VM. Use the VMs IP.

A default Prometheus dashboard can be imported with
on Grafana with `11074` in the Dashboard ID section.

## Default links to web interfaces

- Grafana: http://172.31.0.11:80
- Prometheus: http://172.31.0.11:9090/targets
- Jenkins: http://172.31.0.12:30001
- Nexus: http://172.31.0.13

## Kubernetes Notes

#### Add node to cluster

Once installed scroll up and there will be 2 lines similar to

```
kubeadm join [ip]:[port] --token [token] --discovery-token-ca-cert-hash [hash]
```

Copy this and run it on all Kubernetes nodes as a root user.

```
sudo -i
```

---

To access the Kubernetes Dashboard from outside a VM running Kubernetes, use an SSH tunnel:

```
ssh -i [pub key] vagrant@[ip] -L 8001:localhost:8001
```

then run (on the K8 VM):

```
kubectl proxy
```

Dashboard will be found at:

```
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

---
