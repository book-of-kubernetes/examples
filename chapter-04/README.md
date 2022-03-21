# Network Namespaces

This folder provides the examples for the chapter "Network Namespaces".

## Prerequisites

Be sure to start by following the instructions in the `setup` folder.

## Running in AWS

Start by provisioning:

```
ansible-playbook aws-setup.yaml
```

Then, run the main playbook:

```
ansible-playbook playbook.yaml
```

For this chapter, we create two virtual machines, `host01` and `host02`.
However, `host02` is just a small virtual machine that serves as a target
for `ping` commands so we can illustrate how containers are able to access
the external network, so all of our interaction will be with `host01`.

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

For this chapter, we create two virtual machines, `host01` and `host02`.
However, `host02` is just a small virtual machine that serves as a target
for `ping` commands so we can illustrate how containers are able to access
the external network, so all of our interaction will be with `host01`.

You can SSH to `host01` and become root by running:

```
vagrant ssh host01
sudo su -
```

When finished, you can clean up the VM:

```
vagrant destroy
```
