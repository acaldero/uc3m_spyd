# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Software necesario

### Instalación de Apache Spark

* Para instalar las dependencias relativas a Java puede ejecutar:
  ```
  sudo apt-get install ssh rsync default-jdk
  ```

* Para instalar las dependencias relativas a python puede ejecutar:
  ```
  sudo apt-get install python3-minimal python3-pip jupyter-notebook
  sudo pip install py4j
  ```

* Para instalar Apache Spark en su cuenta personal puede ejecutar:
  ```
  cd $HOME
  wget https://dlcdn.apache.org/spark/spark-4.0.0/spark-4.0.0-bin-hadoop3.tgz
  tar zxf spark-4.0.0-bin-hadoop3.tgz
  ln   -s spark-4.0.0-bin-hadoop3  spark
  ```

* Después de instalar, hay que configurar dos variables de entorno para usar Apache Spark:
  ```
  export SPARK_HOME=$HOME/spark
  export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
  ```

* La prueba básica de que funciona la instalación es:
  ```
  ./spark/bin/run-example SparkPi 5
  ```
  
* Debería de ver una salida como la siguiente:
  ```
  24/10/24 12:18:30 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform...
  ...
  24/10/24 12:18:32 INFO SparkContext: Starting job: reduce at SparkPi.scala:38
  24/10/24 12:18:32 INFO DAGScheduler: Got job 0 (reduce at SparkPi.scala:38) with 5 output partitions
  ...
  24/10/24 12:18:32 INFO DAGScheduler: Job 0 is finished. Cancelling potential speculative or zombie tasks for this job
  24/10/24 12:18:32 INFO TaskSchedulerImpl: Killing all running tasks in stage 0: Stage finished
  24/10/24 12:18:32 INFO DAGScheduler: Job 0 finished: reduce at SparkPi.scala:38, took 0.458716 s
  Pi is roughly 3.143406286812574
  24/10/24 12:18:32 INFO SparkContext: SparkContext is stopping with exitCode 0.
  24/10/24 12:18:32 INFO SparkUI: Stopped Spark web UI at http://master:4040
  24/10/24 12:18:33 INFO MapOutputTrackerMasterEndpoint: MapOutputTrackerMasterEndpoint stopped!
  24/10/24 12:18:33 INFO MemoryStore: MemoryStore cleared
  24/10/24 12:18:33 INFO BlockManager: BlockManager stopped
  24/10/24 12:18:33 INFO BlockManagerMaster: BlockManagerMaster stopped
  24/10/24 12:18:33 INFO OutputCommitCoordinator$OutputCommitCoordinatorEndpoint: OutputCommitCoordinator stopped!
  24/10/24 12:18:33 INFO SparkContext: Successfully stopped SparkContext
  24/10/24 12:18:33 INFO ShutdownHookManager: Shutdown hook called
  24/10/24 12:18:33 INFO ShutdownHookManager: Deleting directory /tmp/spark-aa764165-433d-4601-9365-ee5c1b6c5b82
  24/10/24 12:18:33 INFO ShutdownHookManager: Deleting directory /tmp/spark-0bc7c845-d7ac-43c7-874a-1e8bdb86a92d
  ```


