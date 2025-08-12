# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Laboratorio sobre Alta Escalabilidad en Sistemas Distribuidos

* Máquinas de trabajo:
  * [Sistema dedicado en la nube cloud.lab.inf.uc3m.es](https://github.com/acaldero/uc3m_spyd/blob/main/materiales/INFO_cloud.md)
    * [Pre-requisitos para trabajar en ssddX.cloud.lab.inf.uc3m.es](/materiales/INFO_cloud.md#11-pre-requisitos-para-trabajar-en-ssddxcloudlabinfuc3mes)
    * [Conexión SSH con las máquinas de trabajo](/materiales/INFO_cloud.md#12-conexi%C3%B3n-ssh-con-las-m%C3%A1quinas-de-trabajo)
  * [Sistema propio usando contenedores docker](https://github.com/acaldero/uc3m_spyd/blob/main/materiales/INFO_docker.md)
    * [Pre-requisitos para trabajar con contenedores](/materiales/INFO_docker.md#11-pre-requisitos-para-trabajar-con-contenedores)
    * [Conexión SSH con las máquinas de trabajo](/materiales/INFO_docker.md#12-conexi%C3%B3n-ssh-con-las-m%C3%A1quinas-de-trabajo)

* Software necesario:
  * [Instalación de Python](#instalaci%C3%B3n-de-python-y-pip) 
  * [Instalación de Apache Spark](#instalaci%C3%B3n-de-apache-spark)

* Ejemplos para aprender:
  * [Apache Spark en nodo autónomo y shell interactivo](#apache-spark-en-nodo-aut%C3%B3nomo-y-shell-interactivo)
  * [Ejemplo: cálculo de pi en nodo autónomo y shell interactivo](#ejemplo-c%C3%A1lculo-de-pi-en-nodo-aut%C3%B3nomo-y-shell-interactivo)
  * [Ejemplo: contar ocurrencias de palabras en fichero autónomo y shell interactivo](#ejemplo-contar-ocurrencias-de-palabras-en-fichero-en-nodo-aut%C3%B3nomo-y-shell-interactivo)
  * [Ejemplo: uso de jupyter notebook](#ejemplo-uso-de-jupyter-notebook)
  * [Ejemplo: uso de jupyter notebook con cluster](#ejemplo-uso-de-jupyter-notebook-con-cluster)


## Software necesario

### Instalación de Python (y PIP)  

*  
  <html>
  <table>
  <tr>
  <td>Paso</td>
  <td>Mandato</td>
  </tr>
  <tr>
  <td>Instalar Python3</td>
  <td>
  <small><pre>
  sudo apt-get install python3-minimal python3-pip
  sudo pip install py4j
  </pre></small>
  </td>
  </tr>
  <tr>
  <td>Instalar soporte para jupyter</td>
  <td><pre>sudo apt-get install jupyter-notebook</pre></td>
  </tr>
  <tr>
  <td>Prueba básica</td>
  <td colspan="1"><pre>jupyter notebook</pre></td>
  </tr>
  </table>
  </html>


### Instalación de Apache Spark

* Para instalar las dependencias puede ejecutar:
  ```
  sudo apt-get install ssh rsync default-jdk
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


## Ejemplos para aprender

### Apache Spark en nodo autónomo y shell interactivo

* Para trabajar con un shell interactivo en un nodo autónomo hay que ejecutar:
  ```
  ./spark/bin/pyspark  --master local[2]
  ```
  Donde el parámetro de "--master" puede ser:
  * local	    -> 1 hilo
  * local[N]  -> N hilos
  * local[\*] -> tantos hilos como cores haya en el sistema (nproc --all)


* Tras ejecutar pyspark como se ha indicado anteriormente, la salida debería ser parecida a:
  ```
  Python 3.10.12 (main, Sep 11 2024, 15:47:36) [GCC 11.4.0] on linux
  Type "help", "copyright", "credits" or "license" for more information.
  Setting default log level to "WARN".
  To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
  ...
  Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.5.0
      /_/

  Using Python version 3.10.12 (main, Sep 11 2024 15:47:36)
  Spark context Web UI available at http://master:4040
  Spark context available as 'sc' (master = local[2], app id = local-1729426762360).
  SparkSession available as 'spark'.
  >>>
  ```

* Cuando tengamos que terminar la sesión de trabajo de Apache Spark deberemos ejecutar:
  ```
  quit()
  ```
  También el caracter "final de fichero" (con las teclas control y D) debería de permitir finalizar la sesión con Apache Spark.


### Ejemplo: cálculo de pi en nodo autónomo y shell interactivo

* Para trabajar con un shell interactivo en un nodo autónomo hay que ejecutar:
  ```
  ./spark/bin/pyspark  --master local[*]
  ```

* Spark imprime ">>>" para indicarnos que está a la espera de código Python para ejecutar.
  Vamos a copiar el siguiente código en la terminal:
  ``` python
  import sys
  from random import random
  from operator import add
  from pyspark.sql import SparkSession

  partitions = 2
  n = 100000 * partitions
  def f(_):
     x = random() * 2 - 1
     y = random() * 2 - 1
     return 1 if x ** 2 + y ** 2 < 1 else 0

  spark = SparkSession.builder.appName("PythonPi").getOrCreate()
  count = spark.sparkContext.parallelize(range(1, n + 1), partitions).map(f).reduce(add)
  print("Pi is roughly %f" % (4.0 * count / n))
  spark.stop()
  ```

* Tras introducir el código y dar enter se ejecutará, y la salida debería ser parecida a:
  ```
  >>> import sys
  >>> from random import random
  >>> from operator import add
  >>> from pyspark.sql import SparkSession
  >>>
  >>> partitions = 2
  >>> n = 100000 * partitions
  >>> def f(_):
  ...    x = random() * 2 - 1
  ...    y = random() * 2 - 1
  ...    return 1 if x ** 2 + y ** 2 < 1 else 0
  ...
  >>> spark = SparkSession.builder.appName("PythonPi").getOrCreate()

  24/10/20 12:19:33 WARN SparkSession: Using an existing Spark session; only runtime SQL configurations will take effect.
  >>> count = spark.sparkContext.parallelize(range(1, n + 1), partitions).map(f).reduce(add)
  >>> print("Pi is roughly %f" % (4.0 * count / n))
  Pi is roughly 3.132920
  >>> spark.stop()
  >>>
  ```

* Para terminar la sesión ejecutaremos:
  ```
  quit()
  ```


### Ejemplo: contar ocurrencias de palabras en fichero en nodo autónomo y shell interactivo

* Usaremos el quijote en texto plano para trabajar ([pg2000.txt](https://www.gutenberg.org/files/2000/2000-0.txt)) para lo que usaremos:
  ```
  curl https://www.gutenberg.org/files/2000/2000-0.txt  -o $HOME/lab_spark/2000-0.txt
  ```

* Deberemos borrar cualquier resultado anterior de trabajo:
  ```
  rm -fr   /home/lab/lab_spark/pg2000-w
  ```

* Para trabajar con un shell interactivo en un nodo autónomo hay que ejecutar:
  ```
  ./spark/bin/pyspark  --master local[*]
  ```

* Spark imprime ">>>" para indicarnos que está a la espera de código Python para ejecutar.
  Vamos a copiar el siguiente código en la terminal:
  ``` python
  import sys
  from operator import add
  from pyspark.sql import SparkSession

  sc = SparkSession.builder.appName("pywc").getOrCreate()
  lines = sc.read.text("/home/lab/lab_spark/2000-0.txt").rdd.map(lambda r: r[0])
  counts = lines.flatMap(lambda x: x.split(' ')) \
                .map(lambda x: (x, 1)) \
                .reduceByKey(add)
  output = counts.collect()
  counts.saveAsTextFile("/home/lab/lab_spark/pg2000-w")
  sc.stop()
  ```

* Tras introducir el código y dar enter se ejecutará, y la salida debería ser parecida a:
  ```
  >>> 
  >>> import sys
  >>> from operator import add
  >>> from pyspark.sql import SparkSession
  >>>
  >>> sc = SparkSession.builder.appName("pywc").getOrCreate()

  24/10/20 12:20:27 WARN SparkSession: Using an existing Spark session; only runtime SQL configurations will take effect.
  >>> lines = sc.read.text("/home/lab/lab_spark/2000-0.txt").rdd.map(lambda r: r[0])
  >>> counts = lines.flatMap(lambda x: x.split(' ')) \
  ...               .map(lambda x: (x, 1)) \
  ...               .reduceByKey(add)
  >>> output = counts.collect()
  >>> counts.saveAsTextFile("/home/lab/lab_spark/pg2000-w")
  >>> sc.stop()
  >>>
  ```

* Para terminar la sesión ejecutaremos:
  ```
  quit()
  ```

* Para ver el resultado ejecutaremos:
  ```
  cat /home/lab/lab_spark/pg2000-w/part-00000
  ```


### Ejemplo: uso de jupyter notebook

* Debemos configurar pyspark para que use jupyter y notebook:
  ```
  export PATH=$HOME/spark/bin:$PATH
  export PYSPARK_DRIVER_PYTHON=jupyter
  export PYSPARK_DRIVER_PYTHON_OPTS='notebook --ip=0.0.0.0 --no-browser'
  ```

* A continuación debemos ejecutamos *pyspark*:
  ```
  pyspark
  ```

* En la salida de la ejecución de *pyspark* debemos buscar la URL en la que conectarnos:
  ```
  [I 20:00:53.903 NotebookApp] Serving notebooks from local directory: /home/lab
  [I 20:00:53.903 NotebookApp] Jupyter Notebook 6.5.2 is running at:
  [I 20:00:53.903 NotebookApp] http://master:8888/?token=bcefad0f329df8416ed6c4b40eb9d558bb9e1c4ed4a15ed8
  [I 20:00:53.903 NotebookApp]  or http://127.0.0.1:8888/?token=bcefad0f329df8416ed6c4b40eb9d558bb9e1c4ed4a15ed8
  [I 20:00:53.903 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
  [C 20:00:53.907 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/lab/.local/share/jupyter/runtime/nbserver-97145-open.html
    Or copy and paste one of these URLs:
        http://master:8888/?token=bcefad0f329df8416ed6c4b40eb9d558bb9e1c4ed4a15ed8
     or http://127.0.0.1:8888/?token=bcefad0f329df8416ed6c4b40eb9d558bb9e1c4ed4a15ed8
  ```

* Para conectarnos debemos usar el nombre de la máquina *master* visible en nuestra red, en nuestro caso hay que cambiar *master* por *ssddX.cloud.lab.inf.uc3m.es*: 
  ```
  http://ssdd0.cloud.lab.inf.uc3m.es:8888/?token=bcefad0f329df8416ed6c4b40eb9d558bb9e1c4ed4a15ed8
  ```

* Una vez conectados+as estaremos en la página inicial:  
  ![Image](jn01-intro.png)

* En la página inicial procederemos a crear un nuevo notebook:  
  ![image](jn02-new-notebook.png)
  
* En el nuevo libro tendremos una nueva celda:  
  ![image](jn03-new-cell.png)
  
* En la celda podemos copiar el ejemplo de PI (y ejecutarlo):  
  ![image](jn04-pi.png)
  
* En una nueva celda podemos copiar el ejemplo de contar el número de palabras en local (y ejecutarlo):  
  ![image](jn05-pywc-local.png)
  
* En una nueva celda podemos copiar el ejemplo de contar el número de palabras en remoto (y ejecutarlo):  
  ![image](jn07-pywc-remote-2.png)


### Ejemplo: uso de jupyter notebook con cluster

* Se configura los workers de Spark:
  ```
  echo "nodo1" >> spark/conf/workers
  echo "nodo2" >> spark/conf/workers
  ```

* Todos los nodos han de poder comunicarse con SSH sin precisar clave.  
  En caso de ser necesario, hay que ejecutar:
  ```
  ssh-keygen -t rsa -P ""
  ssh-copy-id -i .ssh/id_rsa.pub lab@nodo1
  ssh-copy-id -i .ssh/id_rsa.pub lab@nodo2
  ```
  Se recomienda este [tutorial de IBM](https://www.ibm.com/support/pages/configuring-ssh-login-without-password) para más información al respecto de este paso.

* Si no hay una cuenta compartida en todos los nodos entonces hay que asegurarse que se tiene la misma copia de Spark en todos los nodos mediante:
  ```
  scp –r spark lab@nodo1:~/
  scp –r spark lab@nodo2:~/
  ```

* En el nodo master hay que arrancar *Spark*:
  ```
  ./spark/sbin/start-all.sh
  ```

* Recuerde antes tener borrado el directorio $HOME/lab_spark/pg2000-w que pueda tener alguna ejecución previa:
  ```
  rm -fr $HOME/lab_spark/pg2000-w
  ```

* El programa cambia solo añadiendo ".master("spark://master:7077")" en nuestro ejemplo:
  ```
  import sys
  from operator import add
  from pyspark.sql import SparkSession

  sc = SparkSession.builder.appName("pywc").master("spark://master:7077").getOrCreate()
  lines = sc.read.text("/home/lab/lab_spark/2000-0.txt").rdd.map(lambda r: r[0])
  counts = lines.flatMap(lambda x: x.split(' ')) \
                .map(lambda x: (x, 1)) \
                .reduceByKey(add)
  output = counts.collect()
  counts.saveAsTextFile("/home/lab/lab_spark/pg2000-w")
  sc.stop()
  ```
  El [tutorial](https://towardsdatascience.com/how-to-connect-jupyter-notebook-to-remote-spark-clusters-and-run-spark-jobs-every-day-2c5a0c1b61df) muestra un entorno parecido.

* Para terminar la sesión ejecutaremos:
  ```
  quit()
  ```

* Para ver el resultado ejecutaremos:
  ```
  cat /home/lab/lab_spark/pg2000-w/part-00000
  ```

* En el nodo master cuando se termine la sesión de trabajo se para *Spark* usando:
  ```
  ./spark/sbin/stop-all.sh
  ```


## Bibliografía de ejemplos de Spark

* [Ejemplos iniciales de uso de Spark](https://spark.apache.org/examples.html)
* [Ejemplos en python](https://github.com/apache/spark/tree/master/examples/src/main/python)


