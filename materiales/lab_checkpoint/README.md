# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Laboratorio sobre soporte para tolerancia a fallos en Sistemas Distribuidos

* Máquinas de trabajo:
  * Opción 1: [Sistema dedicado en la nube cloud.lab.inf.uc3m.es](/materiales/ENV_cloud.md)
  * Opción 2: [Sistema propio usando contenedores docker](/materiales/ENV_docker.md)
* Software necesario:
  * [Instalación de Python](/materiales/SW_python.md)
* Ejemplo para aprender:
  * [Checkpointing](#checkpointing)


## Checkpointing

### 1. Preparación

* Si no tiene el directorio *lab_checkpoint* entonces precisa ejecutar:
  ```
  git clone https://github.com/acaldero/uc3m_spyd.git
  cd uc3m_spyd/materiales
  ```
* Si tiene el directorio *lab_checkpoint* entonces hay que introducir:
  ```
  cd lab_checkpoint
  chmod a+x *.sh
  ```


#### 2. Ejemplo de uso de checkpoint

* Partimos del uso de la librería ```pickle``` que permite guardar un objeto de python en un archivo (y luego recuperarlo), así como de tres primitivas: save, load y remove:
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

* A dichas primitivas se añade el fragmento de código que las utiliza:
  ```python
  import os
  import sys
  import random
  import time

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


### 3. Ejecutar el ejemplo

* La primera vez que se ejecuta el cliente, se realiza un número indeterminado de iteraciones hasta que falla la ejecución:
  <html>
  <table>
  <tr><th>Paso</th><th>Cliente</th></tr>
  <tr>
  <td>1</td>
  <td>

  ```
  ./run.sh
  + python3 app.py
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
  <html>
  <table>
  <tr><th>Paso</th><th>Cliente</th></tr>
  <tr>
  <td>2</td>
  <td>

  ```
  ./run.sh
  + python3 app.py
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


