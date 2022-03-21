## Stress Container Image

This folder contains a simple `Dockerfile` to build a container image for
[stress-ng][stress], a tool that creates CPU, memory, and disk load on a
system. The tool is used to illustrate applying resource limits to containers
to prevent one container from causing issues for another.

[stress]:https://kernel.ubuntu.com/~cking/stress-ng/

This image is published to Docker Hub, so you can use it directly without
having to build it. With Docker:

```
docker run --rm alanhohn/stress
```

The book provides examples of how to run it with other container runtimes.

You are welcome to rebuild this image and publish it to your own container
registry. To build it with Docker, run:

```
docker build -t <tag> .
```
