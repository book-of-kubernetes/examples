# Why Kubernetes Matters

This folder provides the examples for the chapter "Why Kubernetes Matters".

## Prerequisites

Be sure to start by following the instructions in the `setup` folder.

## Ubuntu 24.04 and Kubernetes 1.34 Notes

The Kubernetes packages are now published at `pkgs.k8s.io`, with a separate
repository for each minor version, and `apt-key` is no longer used on Ubuntu
24.04. The variables in `/opt/k8sver` are updated, so install the
Kubernetes packages on each host with these commands instead of the ones in
the book:

```
source /opt/k8sver
curl -fsSL $k8s_repo/Release.key -o /etc/apt/keyrings/kubernetes.asc
echo "deb [signed-by=/etc/apt/keyrings/kubernetes.asc] $k8s_repo/ /" > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubelet=$K8SV kubeadm=$K8SV kubectl=$K8SV
apt-mark hold kubelet kubeadm kubectl
```

Calico now ships its custom resource definitions separately from the
operator. They are too large for a client-side `kubectl apply`, so install
Calico with:

```
kubectl create -f $calico_crds_url
kubectl create -f $calico_url
kubectl apply -f /etc/kubernetes/components/custom-resources.yaml
```

## Running in AWS

Start by provisioning:

```
ansible-playbook aws-setup.yaml
```

Then, run the main playbook:

```
ansible-playbook playbook.yaml
```

This chapter has an optional extra playbook to skip some install steps.
You can use it by running:

```
ansible-playbook extra.yaml
```

You can SSH to `host01` and become root by running:

```
./aws-ssh.sh host01
sudo su -
```

When finished, don't forget to clean up:

```
ansible-playbook aws-teardown.yaml
```

## Running in Vagrant

To start:

```
vagrant up
```

This will also run the main Ansible playbook.

This chapter has an optional extra playbook to skip some install steps.
You can use it by running:

```
vagrant provision --provision-with=extra
```

You can SSH to `host01` and become root by running:

```
vagrant ssh host01
sudo su -
```

When finished, you can clean up the VM:

```
vagrant destroy
```
