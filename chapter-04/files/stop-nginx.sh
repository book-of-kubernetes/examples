#!/bin/bash
crictl stop $N1C_ID $N2C_ID
crictl rm $N1C_ID $N2C_ID
crictl stopp $N1P_ID $N2P_ID
crictl rmp $N1P_ID $N2P_ID
