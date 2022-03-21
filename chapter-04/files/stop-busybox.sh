#!/bin/bash
crictl stop $B1C_ID 
crictl rm $B1C_ID 
crictl stopp $B1P_ID 
crictl rmp $B1P_ID 
