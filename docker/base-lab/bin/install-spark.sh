#!/bin/bash
set -x

# 1) Check arguments
if [ $# -lt 1 ]; then
	echo "Usage: $0 <full path where software will be installed>"
	exit
fi

# 2) Get arguments
DESTINATION_PATH=$1
pip3 install py4j --break-system-packages

# 3) Download and install Spark
mkdir -p ${DESTINATION_PATH}
if [ ! -f ${DESTINATION_PATH}/spark-4.0.0-bin-hadoop3.tgz ]; then
     wget https://dlcdn.apache.org/spark/spark-4.0.0/spark-4.0.0-bin-hadoop3.tgz \
          -O ${DESTINATION_PATH}/spark-4.0.0-bin-hadoop3.tgz
     tar zxf ${DESTINATION_PATH}/spark-4.0.0-bin-hadoop3.tgz -C ${DESTINATION_PATH}
     mv ${DESTINATION_PATH}/spark-4.0.0-bin-hadoop3             ${DESTINATION_PATH}/spark
fi

# 4) PATH
echo "# Spark"                                          >> /home/lab/.profile
echo "export PATH=${DESTINATION_PATH}/spark/bin:\$PATH" >> /home/lab/.profile

