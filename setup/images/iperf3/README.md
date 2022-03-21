## Iperf3 Container Image

This folder contains a simple `Dockerfile` to build a container image for
[iperf3][], a tool that measures IP bandwidth. The tool is used to illustrate 
applying bandwidth limits to containers.

[iperf3]:https://iperf.fr/

This image is published to Docker Hub, so you can use it directly without
having to build it. With Docker:

```
docker run --rm alanhohn/iperf3
```

The image supports the following environment variables:

* `IPERF_SERVER`: Set to a non-empty value to run `iperf3` in server mode.
  This can be used to test bandwidth within a cluster.
* `IPERF_HOST`: In client mode, the host to connect to. Defaults to
  `iperf3-server`.
* `IPERF_ONCE`: Set to a non-empty value to run `iperf3` in client mode once,
  then exit. 

When run as a standalone client, `iperf3` sends data for 10 seconds, then
exits. To increase its utility in a Kubernetes environment, the image contains
an entry script that runs `iperf3` continuously, sleeping for one minute
between runs. You can set `IPERF_ONCE` to any value to override this behavior.

The book provides examples of how to run it in Kubernetes.

You are welcome to rebuild this image and publish it to your own container
registry. To build it with Docker, run:

```
docker build -t <tag> .
```
