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



## Ejemplo para aprender

### Checkpointing

#### 1. Preparación

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


#### 2. Ejecutar el ejemplo

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


