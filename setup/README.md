# Examples Setup

This folder provides some basic setup for the examples used in the book. This
setup uses Ansible to quickly create virtual machines with some important
tools we'll be using to explore containers and Kubernetes. You will need
access to Linux to run Ansible; this could be a cloud machine or Windows
using the [Windows Subsystem for Linux (WSL)][wsl].

[wsl]:https://docs.microsoft.com/en-us/windows/wsl/install-win10

This setup directory supports two different methods for virtual machines:
Amazon Web Services (AWS), or VirtualBox using Vagrant. AWS does not require
any local resources, but you'll pay for the cloud resources you use. Vagrant
uses your local computer to run virtual machines, so you'll need to have at
least 16GB of RAM and 6 processor cores (the more memory and CPUs, the
better).

**NOTE for AWS** The AWS instances created by these playbooks are not
terminated automatically. Remember to terminate the instances using the
`aws-teardown.yaml` playbook!

## Prerequisites

To use this Ansible configuration, you must first install Ansible. This can
be done using the Python package installer, `pip`.

How you install `pip` will depend on your operating system and distribution. 
For example, on Ubuntu:

```
sudo apt update
sudo apt install -y python3-pip
```

## Installing

Install Ansible with pip:

```
pip3 install ansible jmespath
```

This command also installs the `jmespath` Python module, which is needed
for some JSON query processing done as part of the Kubernetes cluster
initialization.

If you already use Ansible and have it installed, note that these examples
were tested with Ansible 2.10.6. They are unlikely to work with any version
of Ansible prior to 2.10.

You can choose to run `sudo` in front of `pip3` commands to install for all
users, but be consistent or Ansible may have problems finding the Python
modules you install.

Also, if you installed Ansible as a regular user, you may need to add
`$HOME/.local/bin` to your `PATH` in order to be able to run Ansible
commands.

## Amazon Web Services

There are some additional setup steps to use AWS.

### Additional Installation

First, run a few more commands that will fetch some dependencies our Ansible
configuration needs:

```
ansible-galaxy collection install -r collections/requirements.yaml
pip3 install -r requirements.txt
pip3 install -r collections/ansible_collections/amazon/aws/requirements.txt
```

You will also need to configure AWS (e.g. using `aws configure`) per the
usual Amazon Web Services instructions. This configuration is used by Ansible
to create resources on your behalf.

Finally, you need to make sure `ssh-keygen` is installed on your system as we
will use it to manage SSH keys to communicate with our instances in AWS. It
is typically installed by default on most Linux distributions.

### Variables

Review the AWS variables in `roles/aws-instances/defaults/main.yaml` to see if
any changes are required. In particular, you might want to change the
`aws_region` to a region that is closest to you. If you do change the region,
you must also change the region in `ec2-inventory/aws_ec2.yaml` to match the
region you selected.

### Running

Once you've completed the setup, you are ready to use AWS to create virtual
machines for each chapter. Just change into the correct directory for that
chapter and run:

```
ansible-playbook aws-setup.yaml
```

Note that creation will take a while as we need to wait for the instance to
finish initializing before we can collect the SSH host key.

**NOTE** Ansible will warn that the instance did not start before timeout.
This is expected and the task to fetch host keys has a retry in it to wait
for instance startup. Also note that if AWS is a little slow in assigning 
a public IP to an instance, Ansible may fail the first time. This is not an
issue; just run it again and it should succeed.

### Teardown

To make sure any AWS instances you've created are cleaned up, just run this
command in this directory or any chapter directory:

```
ansible-playbook aws-teardown.yaml
```

This command will delete any EC2 instances with the `env` tag of
`aws_ansible_k8s`, so it will clean up any instances from all chapters.

### Delete

The `aws-teardown.yaml` playbook leaves some AWS resources intact to save
time when moving from chapter to chapter. These resources don't have any
ongoing associated costs, but if you use the AWS console you may notice
them.

If you want to completely clean up all the examples from this book, you can
run the delete script in this directory to clean up these remaining
resources:

```
ansible-playbook aws-delete.yaml
```

## Vagrant

Each chapter contains a `Vagrantfile` (or, where the chapter explores multiple
different options, multiple directories each holding a `Vagrantfile`). This
allows the use of a separate set of virtual machines for each chapter to
avoid the setup from one chapter conflicting with the next.

To get started with Vagrant, we need a hypervisor. The `Vagrantfile` used
for each chapter is designed for [VirtualBox][vbox], the default hypervisor
for Vagrant. 

[vbox]:https://www.virtualbox.org/

Installation of VirtualBox will be different for each OS or distribution.
For example, on an Ubuntu system, the following command (run as root) should 
work:

```
apt install virtualbox libarchive-tools
```

In general, follow the instructions on the VirtualBox site.

Once VirtualBox is installed, the next step is to install [Vagrant][vagrant]. 
For some distributions, Vagrant is available as a package in the standard
repositories. However, it is best to review [the instructions on the Vagrant
site][vagrant-install] and install using the Hashicorp repositories if 
possible, as the version in the standard repositories may not have all the 
necessary features. For example, Fedora 34 users have reported trouble with 
both Vagrant 2.2.7 and with Vagrant 2.2.19 when installed from the Fedora 
repos.

[vagrant]:https://www.vagrantup.com/
[vagrant-install]:https://developer.hashicorp.com/vagrant/downloads

Thanks to [Xander Soldaat][botbench] and to [Abe Hanoka][abe-101] for their
feedback regarding using Vagrant on Fedora with these examples.

[botbench]:https://github.com/botbench
[abe-101]:https://github.com/abe-101

Once VirtualBox and Vagrant are installed and working, and Ansible is
installed and set up per the instructions above, you can simply run
`vagrant up` in any directory with a `Vagrantfile`. This will automatically
apply the primary automation for that chapter. See the `README.md` file in
each chapter for more information.
