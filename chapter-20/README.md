# Application Resiliency

This folder provides the examples for the chapter "Application Resiliency".

## Important Note

This chapter creates a six-node Kubernetes cluster. Each of the six nodes
is allocated 2 cores and 2 GB of RAM. If you're using the Vagrant setup
to run these examples, it's essential to have at least 16 GB of RAM so there's
room for all these virtual machines plus the host. 32 GB would really be
preferable. Additionally, while the cluster load isn't extremely high once
it reaches a steady state, there is a lot of work on startup. The
`playbook.yaml` file includes a 3 minute pause after the cluster is deployed
before deploying the `todo` application, in an effort to allow the cluster
to settle. On a slower system, it may be necessary to increase this pause
to get the Postgres Operator to deploy the database correctly. Of course,
you can also use AWS for this chapter, or you can run `vagrant provision`
multiple times if you find the application didn't deploy as expected the
first time.

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

You can SSH to `host01` and become root by running:

```
vagrant ssh host01
sudo su -
```

When finished, you can clean up the VM:

```
vagrant destroy
```
