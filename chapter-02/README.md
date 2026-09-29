# Process Isolation

This folder provides the examples for the chapter "Process Isolation".

## Prerequisites

Be sure to start by following the instructions in the `setup` folder.

## Ubuntu 24.04 and Kubernetes 1.34 Notes

The CRI-O packages have moved to a new repository, and `apt-key` is no
longer used on Ubuntu 24.04. The variables in `/opt/crio-ver` are updated
for the new repository, so install CRI-O and `crictl` with these commands
instead of the ones in the book:

```
source /opt/crio-ver
curl -fsSL $REPO/Release.key -o /etc/apt/keyrings/cri-o.asc
echo "deb [signed-by=/etc/apt/keyrings/cri-o.asc] $REPO/ /" > /etc/apt/sources.list.d/cri-o.list
apt update && apt install -y cri-o
systemctl start crio
curl -L -o /tmp/crictl.tar.gz $CRICTL_URL
tar -C /usr/local/bin -xvzf /tmp/crictl.tar.gz
```

There is no longer a separate `cri-o-runc` package; the low-level runtimes
(`crun`, the default, and `runc`) are included in the `cri-o` package.

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

You can SSH to the instance and become root by running:

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

You can SSH to the instance and become root by running:

```
vagrant ssh
sudo su -
```

When finished, you can clean up the VM:

```
vagrant destroy
```
