# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Sistema de colas en avignon.lab.inf.uc3m.es


### 1. Conexión SSH con las máquinas de trabajo

* Si está fuera de la Universidad entonces una opción es primero conectarse a la máquina guernika.lab.inf.uc3m.es:
  ```
  ssh -l <usuario+a cuenta en laboratorio> guernika.lab.inf.uc3m.es
  <usuario+a en lab>@avignon.lab.inf.uc3m.es's password: <clave de la cuenta que no se mostrará cuando escriba>
  Linux avignon-frontend 5.10.0-18-amd64 #1 SMP Debian 5.10.140-1 (2022-09-02) x86_64
  ...
  ```

* A continuación conectarse a la máquina avignon.lab.inf.uc3m.es:
  ```
  ssh -l <usuario+a cuenta en laboratorio> avignon.lab.inf.uc3m.es
  <usuario+a en lab>@avignon.lab.inf.uc3m.es's password: <clave de la cuenta que no se mostrará cuando escriba>
  Linux avignon-frontend 5.10.0-18-amd64 #1 SMP Debian 5.10.140-1 (2022-09-02) x86_64
  ...
  ```

* Una vez que finalice su sesión de trabajo, ha de cerrar cada conexión abierta (avignon, guernika, etc.) usando el mandato exit:
  ```
  exit
  ```


### 2. Uso del sistema de colas de avignon.lab.inf.uc3m.es

* Hay ciertos casos en los que varios usuarios+as han de ejecutar sus programas de forma que los ordenadores que usen (llamados nodos) se asignen en exclusividad para esa persona (en un mismo nodo no se ejecuten los trabajos de dos o más usuarios+as a la vez).
* Uno de estos casos es la ejecución de una aplicación en el menor tiempo posible, no se quiere tener interferencias de la ejecución de otro programa a la vez.
* Para estos casos se usa un sistema de trabajos en cola, que se encarga de asignar nodos durante un tiempo limitado a las personas que lo usen para que puedan trabajar en exclusividad si lo precisan.

#### 2.1 Lanzar un trabajo en la cola
<ol type="a">
  a. Compruebe primero que está conectado a avignon.lab.inf.uc3m.es (que es el nodo front-end o nodo de cabecera)
  
  b. Ha de crear un script con todo lo que quiera ejecutar en ese trabajo encolado.
     Por ejemplo, el script do-work.sh tendrá el siguiente contenido:
```
#!/bin/sh
set -x
hostname
```

  c. A continuación ha de usar sbatch para pedir ejecutar el script como trabajo en cola:
```
sbatch do-work.sh
``` 

  d. Puede que tarde en ejecutarse, para ver el estado en la cola puede ejecutar:
```
squeue
```
Y la salida será:
```
   JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
     555       all  do-work acaldero  R       0:02      1 c54
```
Si no encuentra su trabajo en la lista es que posiblemente haya finalizado ya su ejecución.

  e. Tras su ejecución se genera un archivo slurm-XXX.out (siendo XXX un número que identifica a la petición de ejecución, es decir, el JOBID) por lo que el resultado de su ejecución se puede ver con:
```
cat slurm-XXX.out
```

  x. Si por cualquier razón el trabajo entra en un bucle infinito y no termina, tenemos la posibilidad de cancelarlo con scancel y el identificador de trabajo (JOBID):
```
scancel 555
```
</ol>


#### 2.2 Pedir un trabajo interactivo
<ol type="a">
  a. Compruebe primero que está conectado a avignon.lab.inf.uc3m.es (que es el nodo front-end o nodo de cabecera)
  
  b. Ha de solicitar una sesión interactiva (es útil para depurar o trabajos cortos interactivos):
```
srun --pty /bin/bash
```

  c. A continuación puede ejecutar los mandatos interactivos que precise:
```
hostname
```

  d. Por último ha de finalizar la sesión interactiva:
```
exit
```
</ol>


#### 2.3 Selección de software específico a usar en el trabajo
Es posible que haya disponible distintas implementaciones de un software instaladas, y varias versiones de cada implementación.
Por ejemplo, si hay disponible distintos compiladores de C (gcc, clang, etc.) y varias versiones de alguno de ellos (gcc 10, gcc 12, etc.).<br/>
Para poder seleccionar qué software y qué versión queremos usar para un trabajo particular de entre los disponibles se utiliza el programa **module**.

<ol type="a">
  
  a. Compruebe primero que software está disponible en avignon.lab.inf.uc3m.es (que es el nodo front-end o nodo de cabecera) o en el nodo interactivo con **module available**:
```
module avail
```
Y la salida podría ser:
```
dot  gcc/12.1.0  module-info  modules
```

  b. De la lista de software disponible, si queremos usar por ejemplo **gcc/12.1.0** hay que usar la opción **load**:
```
module load gcc/12.1.0
```

  c. Para listar el software ya cargado hay que usar la opción **list**:
```
module list
```
Y la salida podría ser:
```
Currently Loaded Modulefiles:
 1) gcc/12.1.0
```

  d. Para dejar de usar un software concreto que previamente se había cargado hay que usar la opción **unload**:
```
module unload gcc/12.1.0
```

  e. El siguiente ejemplo muestra cómo es posible añadir el uso de **module** a los trabajos en la cola:
```
#!/bin/sh

# Actualizar variables de entorno definidas en /etc/profile
.  /etc/profile

# Cargar gcc/12.1.0
module load gcc/12.1.0

# Ejemplo de compilar con gcc un archivo main.c
gcc -Wall -g -O2 -o main main.c
```
</ol>


### 3. Ejecución de aplicación paralela en el sistema de colas de avignon.lab.inf.uc3m.es

* Es posible reservar varios nodos para ejecutar un proceso MPI en cada uno de los nodos.
* Todos los procesos ejecutando a la vez forman una aplicación MPI paralela.

#### 3.1 Lanzar un trabajo paralelo en la cola
<ol type="a">
  a. Compruebe primero que está conectado a avignon.lab.inf.uc3m.es (que es el nodo front-end o nodo de cabecera)
  
  b. Ha de crear un script con la orden de necesaria para ejecutar el trabajo paralelo.
     Por ejemplo, el script do-work.sh tendrá el siguiente contenido:
```
#!/bin/sh
set -x

#SBATCH --job-name=SSDD
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:20:00

# From https://stackoverflow.com/questions/65439640/hostfile-with-mpirun-on-multinode-with-slurm
scontrol show hostname $SLURM_JOB_NODELIST | perl -ne 'chomb; print "$_"x1' > hostname.txt

mpirun -np 4 -hostfile hostname.txt uname -a
```

  c. A continuación ha de usar sbatch para pedir ejecutar el script como trabajo en cola indicando el número de nodos (4 en este ejemplo):
```
sbatch -N4 do-work.sh
``` 

  d. Puede que tarde en ejecutarse, para ver el estado en la cola puede ejecutar:
```
squeue
```
Y la salida será:
```
   JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
     555       all  do-work acaldero  R       0:02      1 c54
```
Si no encuentra su trabajo en la lista es que posiblemente haya finalizado ya su ejecución.

  e. Tras su ejecución se genera un archivo slurm-XXX.out (siendo XXX un número que identifica a la petición de ejecución, es decir, el JOBID) por lo que el resultado de su ejecución se puede ver con:
```
cat slurm-XXX.out
```

  x. Si por cualquier razón el trabajo entra en un bucle infinito y no termina, tenemos la posibilidad de cancelarlo con scancel y el identificador de trabajo (JOBID):
```
scancel 555
```
</ol>


## Agradecimientos

Agradecer al personal del Laboratorio del Departamento de Informática toda la ayuda prestada para la puesta en marcha de los laboratorios propuestos en las máquinas del Laboratorio del Departamento de Informática.


