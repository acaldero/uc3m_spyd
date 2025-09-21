# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Laboratorio de HPC en Sistemas Distribuidos

* Máquinas de trabajo:
  * Opción 1: [Sistema dedicado en la nube cloud.lab.inf.uc3m.es](/materiales/ENV_cloud.md)
  * Opción 2: [Sistema propio usando contenedores docker](/materiales/ENV_docker.md)
* Software necesario:
  * [Instalación de MPI](/materiales/SW_openmpi.md)
* Ejemplos con MPI para aprender:
  * [Hola mundo en MPI](#1-hola-mundo-en-mpi)
  * [Send y Receive en MPI](#2-send-y-receive-en-mpi)
  * [Cálculo de PI en MPI](3-c%C3%A1lculo-de-pi-en-mpi)
* Más ejemplos:
  * [Cálculo de PI en OpenMP vs MPI](#4-c%C3%A1lculo-de-pi-en-openmp-vs-mpi)


### 1. Hola mundo en MPI

Se parte de un archivo fuente vacío y el ciclo de trabajo típico es un bucle con los siguientes pasos en cada iteración:

 1. Editar el archivo fuente con la funcionalidad deseada.
    * Anotar como comentario lo que se quiere hacer
    * Después de cada comentario añadir el código fuente asociado.
 2. Compilar el archivo fuente a binario.
    * Eliminar errores de compilación.
 3. Ejecutar el archivo binario:
    * En local: Eliminar errores de ejecución.
    * En remoto: Eliminar errores de ejecución que hayan quedado.

</br>

#### 1.1. Editar "hola mundo" en MPI

* Hay que editar un archivo [hola_mpi.c](hola_mpi.c) con un contenido similar a:
  ```c
  #include <stdio.h>
  #include <mpi.h>

  int main(int argc, char** argv)
  {
   int world_size;
   int world_rank;
   char processor_name[MPI_MAX_PROCESSOR_NAME];
   int name_len;

   // Primera llamada MPI: inicializar la implementación
   MPI_Init(&argc, &argv);

   // Obtener el número de procesos e identificador del proceso actual (rank)
   MPI_Comm_size(MPI_COMM_WORLD, &world_size);
   MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

   // Obtener el nombre de la máquina
   MPI_Get_processor_name(processor_name, &name_len);

   // Imprimir hola mundo...
   printf("Hola mundo desde '%s' (rank %d de %d)\n",
          processor_name, world_rank, world_size);

   // Última llamada MPI a usar en el programa
   MPI_Finalize();
  }
  ```


#### 1.2. Compilar "hola mundo" en MPI

* Para compilar hay que usar ```mpicc```:
  ```bash
  cd materiales/lab_mpi
  mpicc -g -Wall -c hola_mpi.c -o hola_mpi.o
  mpicc -g -Wall -o hola_mpi hola_mpi.o
  ```

#### 1.3 Ejecutar "hola mundo"

#### 1.3.A En nodo local

Para ejecutar en la máquina local hay que hacer dos pasos:
  1 .Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
    ```bash
    cat <<EOF > machines
    localhost
    localhost
    EOF
    ```
  2. Ha de lanzarse la ejecución en las máquinas deseadas usando ```mpirun```:
    ```bash
    mpirun -np 2 -machinefile machines --map-by node ./hola_mpi
    ```

La salida podría ser:
```bash
Hola mundo desde 'master' (rank 1 de 2)
Hola mundo desde 'master' (rank 0 de 2)
```

#### 1.3.B En nodos remotos

Para ejecutar en dos nodos hay que hacer tres pasos:
 1. Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
    ```bash
    cat <<EOF > machines
    nodo1
    nodo2
    EOF
    ```
 2. Ha de tener el ejecutable en todos los nodos (si no se tiene un directorio de cuenta compartido en las máquinas):
    ```bash
    ssh nodo1 mkdir -p ~/materiales/lab_mpi
    ssh nodo2 mkdir -p ~/materiales/lab_mpi
    scp hola_mpi nodo1:~/materiales/lab_mpi/hola_mpi
    scp hola_mpi nodo2:~/materiales/lab_mpi/hola_mpi
    ```
 3. Ha de lanzarse la ejecución en las máquinas deseadas usando ```mpirun```:
    ```bash
    mpirun -np 4 -machinefile machines --map-by node ~/materiales/lab_mpi/hola_mpi
    ```

La salida podría ser:
```bash
Hola mundo desde 'nodo2' (rank 3 de 4)
Hola mundo desde 'nodo1' (rank 0 de 4)
Hola mundo desde 'nodo2' (rank 1 de 4)
Hola mundo desde 'nodo1' (rank 2 de 4)
```


### 2. Send y Receive en MPI

#### 2.1. Editar

* Hay que editar un archivo [sr_mpi.c](sr_mpi.c) con un contenido similar a:
  ```c
  #include <stdio.h>
  #include "mpi.h"

  int main ( int argc, char **argv )
  {
        int  node, size;
        int  num = 10;
        char name[255];
        MPI_Status status;

        MPI_Init(&argc,&argv);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &node);

        if (node == 0)
             MPI_Send(&num, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
        else MPI_Recv(&num, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);

        MPI_Finalize();

        return 0 ;
  }
  ```


#### 2.2. Compilar

* Para compilar hay que usar mpicc:
  ```bash
  mpicc -o sr_mpi sr_mpi.c -lm
  ```


#### 2.3. Ejecutar (remoto)

Para ejecutar en dos nodos hay que hacer tres pasos:
 1. Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
    ```bash
    cat <<EOF > machines
    nodo1
    nodo2
    EOF
    ```
 2. Ha de tener el ejecutable en todos los nodos (si no se tiene un directorio de cuenta compartido en las máquinas):
    ```bash
    scp sr_mpi nodo1:~/materiales/lab_mpi/sr_mpi
    scp sr_mpi nodo2:~/materiales/lab_mpi/sr_mpi
    ```
 3. Ha de lanzarse la ejecución en las máquinas deseadas usando ```mpirun```:
    ```bash
    mpirun -np 2 -machinefile machines --map-by node ~/materiales/lab_mpi/sr_mpi
    ```

La salida será:
```bash
```
Porque en la ejecución correcta del programa no se imprime nada.


### 3. Cálculo de PI en MPI

#### 3.1. Editar

Hay que editar un archivo [pi_mpi.c](pi_mpi.c) con un contenido similar a:
```c
/* From https://www.mcs.anl.gov/research/projects/mpi/tutorial/mpiexmpl/src/pi/C/main.html */

#include "mpi.h"
#include <math.h>
#include <stdio.h>

int main ( int argc, char *argv[] )
{
    int done = 0, n, myid, numprocs, i;
    double PI25DT = 3.141592653589793238462643;
    double mypi, pi, h, sum, x;

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);
    while (!done)
    {
	if (myid == 0) {
	    printf("Enter the number of intervals: (0 quits) ");
	    scanf("%d",&n);
	}
	MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
	if (n == 0) break;

	h   = 1.0 / (double) n;
	sum = 0.0;
	for (i = myid + 1; i <= n; i += numprocs) {
	    x = h * ((double)i - 0.5);
	    sum += 4.0 / (1.0 + x*x);
	}
	mypi = h * sum;

	MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0,
		   MPI_COMM_WORLD);

	if (myid == 0)
	    printf("pi is approximately %.16f, Error is %.16f\n",
		   pi, fabs(pi - PI25DT));
    }
    MPI_Finalize();
    return 0;
}
```


#### 3.2. Compilar

* Para compilar hay que usar mpicc:
  ```bash
  mpicc -o pi_mpi pi_mpi.c -lm
  ```


#### 3.3. Ejecutar (remoto)

Para ejecutar en dos nodos hay que hacer tres pasos:
 1. Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
    ```bash
    cat <<EOF > machines
    nodo1
    nodo2
    EOF
    ```
 2. Ha de tener el ejecutable en todos los nodos (si no se tiene un directorio de cuenta compartido en las máquinas):
    ```bash
    scp pi_mpi nodo1:~/materiales/lab_mpi/pi_mpi
    scp pi_mpi nodo2:~/materiales/lab_mpi/pi_mpi
    ```
 3. Ha de lanzarse la ejecución en las máquinas deseadas usando mpirun:
    ```bash
    mpirun -np 2 -machinefile machines --map-by node ~/materiales/lab_mpi/pi_mpi
    ```

La salida será:
```bash
Enter the number of intervals: (0 quits) 10
pi is approximately 3.1424259850010983, Error is 0.0008333314113051
Enter the number of intervals: (0 quits) 100
pi is approximately 3.1416009869231241, Error is 0.0000083333333309
Enter the number of intervals: (0 quits) 1000
pi is approximately 3.1415927369231254, Error is 0.0000000833333322
Enter the number of intervals: (0 quits) 10000
pi is approximately 3.1415926544231318, Error is 0.0000000008333387
Enter the number of intervals: (0 quits) 100000
pi is approximately 3.1415926535981016, Error is 0.0000000000083085
Enter the number of intervals: (0 quits) 1000000
pi is approximately 3.1415926535899388, Error is 0.0000000000001457
Enter the number of intervals: (0 quits) 0
```

Agradecer a Lucas la pregunta de qué pasa con 1000000000000 (12 ceros).
Con 13 ceros parece funcionar, pero es posible que haya overflow/underflow en algún cálculo a partir de un número alto de intervalos.


### 4. Cálculo de PI en OpenMP vs MPI

#### 4.1. Editar código para ambas versiones

Hay que editar un archivo [pi_omp_1000000000.c](pi_omp_1000000000.c) con un contenido similar a:
```c
#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

#define N 1000000000
#define d 1E-9

int main ( int argc, char* argv[] )
{
    long long i;
    double PI = 0.0, result = 0.0;

    #pragma omp parallel for reduction(+:result)
    for (i = 0; i < N; i++) {
        double x = d * i;
        result += sqrt(4 * (1 - x * x)) * d;
    }

    PI = 2 * result;
    printf("PI = %f\n", PI);

    return 0;
}
```

Hay que editar un archivo [pi_mpi_1000000000.c](pi_mpi_1000000000.c) con un contenido similar a:
```c
#include <stdio.h>
#include <math.h>
#include "mpi.h"

#define N 1000000000
#define d 1E-9

int main ( int argc, char *argv[] )
{
    int    myid, numprocs, i;
    double PI25DT = 3.141592653589793238462643;
    double mypi, pi, h, sum, x;

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);

    h   = 1.0 / (double) N;
    sum = 0.0;
    for (i = myid + 1; i <= N; i += numprocs) {
         x = h * ((double)i - 0.5);
         sum += 4.0 / (1.0 + x*x);
    }
    mypi = h * sum;

    MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if (myid == 0) {
        printf("pi is approximately %.16f, Error is %.16f\n",
               pi, fabs(pi - PI25DT));
    }

    MPI_Finalize();
    return 0;
}
```


#### 4.2. Compilar

* Para compilar hay que usar gcc y mpicc:
  ```bash
  gcc -O2 -o pi_omp_1000000000 pi_omp_1000000000.c -lm -fopenmp -lpthread
  mpicc -O2 -o pi_mpi_1000000000 pi_mpi_1000000000.c -lm
  ```


#### 4.3. Ejecutar

* Para ejecutar con OpenMP, se puede usar:
  ```bash
  time OMP_NUM_THREADS=8  ./pi_omp_1000000000
  ```

* La salida puede ser:
  ```bash
  PI = 3.141593

  real    0m0.187s
  user    0m1.909s
  sys     0m0.000s
  ```

* Para ejecutar con MPI, se puede usar:
  ```bash
  mpirun -np 8 ./pi_mpi_1000000000
  ```

* La salida puede ser:
  ```bash
  pi is approximately 3.1415926535899708, Error is 0.0000000000001776
  ...

  real    0m0.845s
  user    0m2.154s
  sys     0m0.000s
  ```


## Bibliografía de ejemplos de MPI

* [hola_mpi.c](https://github.com/mpitutorial/mpitutorial/tree/gh-pages/tutorials/mpi-hello-world/code)
* [pi_mpi.c](https://www.mcs.anl.gov/research/projects/mpi/tutorial/mpiexmpl/src/pi/C/main.html)
* [llamadas colectivas](https://github.com/mpitutorial/mpitutorial/tree/gh-pages/tutorials/mpi-broadcast-and-collective-communication)

