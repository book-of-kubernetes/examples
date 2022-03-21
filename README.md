# The Book of Kubernetes

This repository provides examples for The Book of Kubernetes by Alan
Hohn, published by No Starch Press. The examples for each chapter are
self-contained in a directory for each chapter.

The examples make extensive use of virtual machines, both to enable running
a complete cluster and to isolate experimentation into a temporary
environment. The examples support both Vagrant and Amazon Web Services (AWS).

## Getting Started

Start by following the instructions in the `setup` directory's `README.md`
file. Then you'll be ready to use the `README.md` file in each chapter's
folder to run examples for that chapter.

## Automated Configuration

The examples use Ansible to provide automated configuration of the virtual
machines once they're started. The setup instructions will help you get
Ansible installed. All of the chapters have a base `playbook.yaml` file that
provides essential configuration to run the chapter's examples. Some of the
chapters also provide an `extra.yaml` playbook that can be used to skip some
of the less exciting installation and configuration. Instructions for using
the playbooks are found in each chapter's `README.md` file.

The book itself will walk you through everything you need to know about
installing, configuring, and using container runtimes and Kubernetes.
However, the Ansible roles in the `setup/roles` directory are also an
excellent resource to understand the setup of container runtimes and
Kubernetes. You're welcome to reuse this Ansible automation in your own work,
consistent with the license found in the `LICENSE` file. Of course, specific
design choices I made to keep this content easy to use as examples for a book
will not be suitable for production use, so be sure to modify accordingly
and test thoroughly.

## High Availability

One difference between Vagrant and AWS is load balancing to provide a
high-availability solution for the API server and ingress. In Vagrant, these
examples use `kube-vip`. In AWS, they use an Elastic Load Balancer
(specifically a network load balancer). Here I provide some background in case
it's helpful.

For the Vagrant solution, I started with Keepalived, an excellent library for
sharing an IP address between two or more servers. It is a great fit for a
shared IP on bare metal servers as it doesn't require any special network
configuration or a separate set of load balancing servers. However, after some
playing with `kube-vip`, I became convinced that it represents a better
solution for Kubernetes high availability outside of cloud environments, as it
provides similar functionality and can be easily integrated into the cluster
itself.

Unfortunately, what works well in bare metal and Vagrant does not work as well
in AWS. What `keepalived` and `kube-vip` both require is for the underlying
network to be OK with a server suddenly ARPing an additional IP address, and
AWS Virtual Private Cloud (VPC) is definitely **not** OK with that, thank you
very much.  There is [a clever workaround][sf] that watches Keepalived to
follow the shared IP and configures AWS to add that IP to the current master,
but I did not feel that the added complexity of that solution lends itself to
being reliable enough for the examples for a book.

[sf]:https://serverfault.com/questions/436039/is-it-not-possible-to-use-keepalived-in-ec2

Additionally, the right way to deploy a cluster to a cloud environment is to
take advantage of the available features. In the case of AWS, this means
deploying an Elastic Load Balancer (ELB). I was initially concerned about the
complexity of this approach and the risk of exposing a lab cluster to the
outside Internet, so I started with a separate EC2 instance to carry the
`172.31.1.10` IP address and run HAProxy to load balance traffic across the
cluster's API server instances. That was not a real high availability
solution, as HAProxy and its AWS instance are single points of failure, so I
was never satisfied with it.

Ultimately, I was able to get a network load balancer going with an address
solely on the private `172.31/16` network I'm using for the examples. This
required only minimal additions to the `aws-instances` Ansible role, which is
good, because that is already the most complex in the whole set of roles used
for these examples, not least because I have to create and remove resources
without interfering with the rest of someone's AWS account, as well as
automate SSH access to these temporary instances without leaving a bunch of
cruft in `$HOME/.ssh`. Solving this with Ansible is also good because I didn't
want to introduce a whole 'nother tool like Terraform that readers would have
to install and configure.

The only remaining evidence of this churn is the existence of `keepalived` and
`haproxy` roles in `setup/roles`. I decided to leave them there in case they
are useful to someone, but they are not used in the playbook files in the
chapters.

So long story short, as I said above, the Vagrant cluster uses `kube-vip`,
while the AWS cluster uses a network load balancer. In both cases, the
Kubernetes cluster setup is largely identical, which was one of my purposes in
offering two ways to deploy the same cluster. If you're deploying a real
production cluster, you can use the `kube-vip` and AWS load balancer setup for
your own purposes, though you'll have to make some changes to make a cluster
available publicly.

Better yet, use a Kubernetes provider that will set up your cloud provider for
you properly. There are many good options, including Elastic Kubernetes
Service (EKS), Google Kubernetes Engine (GKE), and Azure Kubernetes Service
(AKS), as well as cloud-agnostic Kubernetes distributions like Rancher
Kubernetes Engine (RKE), Tanzu Kubernetes Grid (TKG), and Red Hat OpenShift.
