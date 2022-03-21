#!/bin/bash
crictl pull docker.io/library/busybox:latest
B1P_ID=$(crictl runp busybox-pod.yaml)
B1C_ID=$(crictl create $B1P_ID busybox-container.yaml busybox-pod.yaml)
crictl start $B1C_ID

export B1P_ID B1C_ID 
