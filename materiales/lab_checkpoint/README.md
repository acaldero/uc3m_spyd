# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Laboratorio sobre soporte para tolerancia a fallos en Sistemas Distribuidos

* Entorno hardware y software:
  * Máquinas de trabajo:
    * Opción 1: [Sistema dedicado en la nube cloud.lab.inf.uc3m.es](/materiales/ENV_cloud.md)
    * Opción 2: [Sistema propio usando contenedores docker](/materiales/ENV_docker.md)
  * Software necesario:
    * [Instalación de Python](/materiales/SW_python.md)
* Ejemplo para aprender:
  * [Checkpointing](#checkpointing)


## Checkpointing

### 1. Editar ejemplo

* Hay que acceder al directorio de trabajo:
  ```bash
  mkdir -p ~/lab_checkpoint
  cd       ~/lab_checkpoint
  ```
* Hay que editar un archivo [app.py](app.py) con un contenido similar a:
  ```python
  import os
  import sys
  import pickle
  import random
  import time

  def chkpnt_save ( state ):
    try:
       with open("checkpoint.pickle", "wb") as outfile:
            pickle.dump(state, outfile)
       return 1
    except Exception as e:
       return -1

  def chkpnt_load ( ):
    try:
        with open("checkpoint.pickle", "rb") as infile:
             state = pickle.load(infile)
        return state
    except Exception as e:
        return None

  def chkpnt_remove():
    os.remove("checkpoint.pickle")
    return 1

  #
  # Main
  #

  # try to restart from last checkpoint...
  state = chkpnt_load()
  if state == None:
     state = {"iter": 0}

  while state['iter'] < 50:
     # save checkpoint
     print('iter: ', state['iter'])
     chkpnt_save(state)

     # processing that can fail...
     time.sleep(1)
     dice = random.randint(0,9)
     if (dice > 7):
         print('\U0001F9E8', '\U0001F9E8')
         sys.exit()

     # next iteration
     state['iter'] = state['iter'] + 1

  # remove checkpoint
  chkpnt_remove()
  ```


* Para trabajar con un checkpoint se usa la librería ```pickle``` (que permite guardar un objeto de python en un archivo así como luego recuperarlo) y se implementa tres primitivas: save, load y remove:
  ```python
  import pickle

  def chkpnt_save ( state ):
    try:
       with open("checkpoint.pickle", "wb") as outfile:
            pickle.dump(state, outfile)
       return 1
    except Exception as e:
       return -1

  def chkpnt_load ( ):
    try:
        with open("checkpoint.pickle", "rb") as infile:
             state = pickle.load(infile)
        return state
    except Exception as e:
        return None

  def chkpnt_remove():
    os.remove("checkpoint.pickle")
    return 1
  ```

* El uso de dichas primitivas en el ejemplo es el siguiente:
  ```python
  import os
  import sys
  import random
  import time

  # try to restart from last checkpoint...
  state = chkpnt_load()             # LOAD
  if state == None:
     state = {"iter": 0}

  while state['iter'] < 50:
     # save checkpoint
     print('iter: ', state['iter'])
     chkpnt_save(state)              # SAVE

     # processing that can fail...
     time.sleep(1)
     dice = random.randint(0,9)
     if (dice > 7):
         print('\U0001F9E8', '\U0001F9E8')
         sys.exit()

     # next iteration
     state['iter'] = state['iter'] + 1

  # remove checkpoint
  chkpnt_remove()                    # REMOVE
  ```


### 2. Ejecutar el ejemplo

* La primera vez que se ejecuta el cliente, se realiza un número indeterminado de iteraciones hasta que falla la ejecución:
  * Ejecutaremos:
    ```python
    python3 app.py
    ```
  * Y una posible salida sería:
    <html>
    <table>
    <tr><th>Paso</th><th>Cliente</th></tr>
    <tr>
    <td>1</td>
    <td>

    ```
    iter:  0
    iter:  1
    iter:  2
    iter:  3
    iter:  4
    🧨 🧨
    ```

    </td>
    </tr>
    </table>
    </html>

* Gracias a guardar un punto de recuperación (*checkpoint*) la segunda vez que se ejecuta se continua la ejecución hasta el siguiente fallo (o finalización del programa sin fallo):
  * Ejecutaremos de nuevo:
    ```python
    python3 app.py
    ```
  * Y una posible salida sería:
    <html>
    <table>
    <tr><th>Paso</th><th>Cliente</th></tr>
    <tr>
    <td>2</td>
    <td>

    ```
    iter:  4
    iter:  5
    iter:  6
    iter:  7
    iter:  8
    iter:  9
    🧨 🧨
    ```

    </td>
    </tr>
    </table>
  </html>

