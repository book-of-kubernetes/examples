#!/bin/bash
crictl pull docker.io/library/nginx:latest
N1P_ID=$(crictl runp nginx1-pod.yaml)
N1C_ID=$(crictl create $N1P_ID nginx1-container.yaml nginx1-pod.yaml)
crictl start $N1C_ID

N2P_ID=$(crictl runp nginx2-pod.yaml)
N2C_ID=$(crictl create $N2P_ID nginx2-container.yaml nginx2-pod.yaml)
crictl start $N2C_ID

export N1P_ID N1C_ID N2P_ID N2C_ID
