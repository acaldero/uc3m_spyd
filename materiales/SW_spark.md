# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2026-2027](https://img.shields.io/badge/Curso-2026_2027-red.svg)
&nbsp; ![Curso 2026-2027](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Software necesario

### Instalación de Apache Spark

* Para instalar las dependencias relativas a Java puede ejecutar:
  ```
  sudo apt-get install ssh rsync default-jdk
  ```

* Para instalar las dependencias relativas a python puede ejecutar:
  ```
  sudo apt-get install python3-minimal python3-pip jupyter-notebook
  sudo pip install py4j --break-system-packages
  ```

* Para instalar Apache Spark en su cuenta personal puede ejecutar:
  ```
  cd $HOME
  wget https://dlcdn.apache.org/spark/spark-4.2.0/spark-4.2.0-bin-hadoop3.tgz
  tar zxf spark-4.2.0-bin-hadoop3.tgz
  ln   -s spark-4.2.0-bin-hadoop3  spark
  ```

* Después de instalar, hay que configurar dos variables de entorno para usar Apache Spark:
  ```
  export SPARK_HOME=$HOME/spark
  export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
  ```

* La prueba básica de que funciona la instalación es ejecutar el ejemplo SparkPi:
  ```
  ./spark/bin/run-example SparkPi 5
  ```
  
* Debería de ver una salida parecida a la siguiente:
  ```
  WARNING: Using incubator modules: jdk.incubator.vector
  26/10/12 18:41:28 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
  Using Spark's default log4j profile: org/apache/spark/log4j2-defaults.properties
  26/10/12 18:41:29 INFO SparkContext: Running Spark version 4.2.0
  26/10/12 18:41:29 INFO SparkContext: OS info Linux, 6.8.0-139-generic, amd64
  26/10/12 18:41:29 INFO SparkContext: Java version 21.0.12.1+1-1-24.04.4-Ubuntu
  ...
  26/10/12 18:41:33 INFO DAGScheduler: Job 0 finished: reduce at SparkPi.scala:38, took 403.931982 ms
  Pi is roughly 3.1431422862845726
  ...
  26/10/12 18:41:33 INFO MapOutputTrackerMasterEndpoint: MapOutputTrackerMasterEndpoint stopped!
  26/10/12 18:41:33 INFO MemoryStore: MemoryStore cleared
  26/10/12 18:41:33 INFO BlockManager: BlockManager stopped
  26/10/12 18:41:33 INFO BlockManagerMaster: BlockManagerMaster stopped
  26/10/12 18:41:33 INFO OutputCommitCoordinator$OutputCommitCoordinatorEndpoint: OutputCommitCoordinator stopped!
  26/10/12 18:41:33 INFO SparkContext: Successfully stopped SparkContext (Uptime: 3372 ms)
  ```


