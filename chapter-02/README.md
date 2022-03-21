# Process Isolation

This folder provides the examples for the chapter "Process Isolation".

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
