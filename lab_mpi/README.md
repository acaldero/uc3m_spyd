## Materiales para Sistemas Distribuidos

<html>
<ul>
<li> <a href="https://github.com/acaldero/uc3m_ssdd/blob/main/LICENSE">License</a> </li>
<li> Curso 2022-2023</li>
</ul>
</html>


## Laboratorio de HPC en Sistemas Distribuidos

1 Máquinas de trabajo:
  * [1.1 Pre-requisitos para trabajar en ssddX.cloud.lab.inf.uc3m.es](#11-pre-requisitos-para-trabajar-en-ssddxcloudlabinfuc3mes)
  * [1.2 Conexión SSH con las máquinas de trabajo](#12-conexión-ssh-con-las-máquinas-de-trabajo)

2 Software necesario:
  * [2.1 Instalación del paquete de desarrollo](#21-instalación-del-paquete-de-desarrollo)
  * [2.2 Instalación de MPI](#22-instalación-de-mpi)

3 Ejemplos para aprender:
  * [3.1 Hola mundo en MPI](#31-hola-mundo-en-mpi)
  * [3.2 Send y Receive en MPI](#32-send-y-receive-en-mpi)
  * [3.3 Cálculo de PI en MPI](#33-cálculo-de-pi-en-mpi)

[Agradecimientos](#agradecimientos)



## 1 Máquinas de trabajo

### 1.1 Pre-requisitos para trabajar en ssddX.cloud.lab.inf.uc3m.es

Ha de disponer de:
1. Cuenta en el Laboratorio del Departamento de Informática.
2. El software MobaXterm (o similar).
3. Estar conectado dentro de la red de la Universidad, ya sea con VPN o con conexión a través de guernika.lab.inf.uc3m.es.

Como ayuda:
1. Para solicitar la apertura de cuenta siga los pasos indicados en: https://www.lab.inf.uc3m.es/servicios/apertura-de-cuenta/
2. El Laboratorio del Departamento de Informática dispone de un manual de MobaXterm en: https://www.lab.inf.uc3m.es/wp-content/docs/Manual_ConexionSSH.pdf
3. La información de VPN para la Universidad está en: https://www.uc3m.es/sdic/servicios/vpn

### 1.2 Conexión SSH con las máquinas de trabajo

* Estando dentro de la Universidad para iniciar la sesión de trabajo ha de conectarse a ssddX.cloud.lab.inf.uc3m.es, siendo X = {0, 1, ... 8}:
```
ssh  lab@ssdd0.cloud.lab.inf.uc3m.es
lab@ssdd0.lab.inf.uc3m.es's password: <clave que no se mostrará cuando escriba>
Linux ssdd0...
...
```

* Una vez que finalice su sesión de trabajo, ha de cerrar cada conexión abierta usando el mandato exit:
```
exit
```


## 2 Software necesario

### 2.1 Instalación del paquete de desarrollo

Instalar compilador y depurador:
```
sudo apt-get install build-essential autoconf automake libtool m4
```

Instalar software adicional de apoyo:
```
sudo apt-get install gdb ddd valgrind cgdb
```

### 2.2 Instalación de MPI

Instalar una implementación de MPI:
```
sudo apt-get install mpich libmpich-dev libmpich12 
```

Instalar software adicional de apoyo:
```
sudo apt-get install valgrind-mpi 
```


## 3 Ejemplos para aprender

Se parte de un archivo fuente vacío y el ciclo de trabajo típico es un bucle con los siguientes pasos en cada iteración:

 1 Editar el archivo fuente para añadir funcionalidad.
   * Anotar como comentario lo que se quiere hacer
   * Después de cada comentario añadir el código fuente asociado.

 2 Compilar el archivo fuente a binario.
   * Eliminar errores de compilación.

 3 Ejecutar el archivo binario.
   * Eliminar errores de ejecución.


### 3.1 Hola mundo en MPI

#### 1. Editar "hola mundo" en MPI

Hay que editar un archivo [hola.c](hola.c) con un contenido similar a:
``` C
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


#### 2. Compilar "hola mundo" en MPI

Para compilar hay que usar mpicc:
``` bash
mpicc -g -Wall -c hola.c -o hola.o
mpicc -g -Wall -o hola hola.o
```


#### 3. Ejecutar en nodo local

Para ejecutar en la máquina local hay que hacer dos pasos:
   * Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
``` bash
cat <<EOF > machines
localhost
localhost
EOF
```
  * Ha de lanzarse la ejecución en las máquinas deseadas usando mpirun:
``` bash
mpirun -np 2 -machinefile machines ./hola
```


#### 4. Ejecutar en nodos remotos

Para ejecutar en dos nodos hay que hacer tres pasos:
  * Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
``` bash
cat <<EOF > machines
nodo1
nodo2
EOF
```
  * Ha de tener el ejecutable en todos los nodos (si no se tiene un directorio de cuenta compartido en las máquinas):
``` bash
scp hola nodo1:~/hola
scp hola nodo2:~/hola
```
  * Ha de lanzarse la ejecución en las máquinas deseadas usando mpirun:
``` bash
mpirun -np 4 -machinefile machines ~/hola
```
La salida será:
``` bash
Hola mundo desde 'nodo2' (rank 1 de 4)
Hola mundo desde 'nodo1' (rank 0 de 4)
Hola mundo desde 'nodo1' (rank 2 de 4)
Hola mundo desde 'nodo2' (rank 3 de 4)
```


### 3.2 Send y Receive en MPI

#### 1. Editar

Hay que editar un archivo [s-r.c](s-r.c) con un contenido similar a:
``` C
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


#### 2. Compilar

Para compilar hay que usar mpicc:
``` bash
mpicc -o s-r s-r.c -lm
```


#### 3. Ejecutar (remoto)

Para ejecutar en dos nodos hay que hacer tres pasos:
  * Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
``` bash
cat <<EOF > machines
nodo1
nodo2
EOF
```
  * Ha de tener el ejecutable en todos los nodos (si no se tiene un directorio de cuenta compartido en las máquinas):
``` bash
scp s-r nodo1:~/s-r
scp s-r nodo2:~/s-r
```
  * Ha de lanzarse la ejecución en las máquinas deseadas usando mpirun:
``` bash
mpirun -np 2 -machinefile machines ~/s-r
```
La salida será:
``` bash
```
Porque en la ejecución correcta del programa no se imprime nada.


### 3.3 Cálculo de PI en MPI

#### 1. Editar

Hay que editar un archivo [pi.c](pi.c) con un contenido similar a:
``` C
/* From https://www.mcs.anl.gov/research/projects/mpi/tutorial/mpiexmpl/src/pi/C/main.html */

#include "mpi.h"
#include <math.h>
#include <stdio.h>

int main(argc,argv)
int argc;
char *argv[];
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


#### 2. Compilar

Para compilar hay que usar mpicc:
``` bash
mpicc -o pi pi.c -lm
```


#### 3. Ejecutar (remoto)

Para ejecutar en dos nodos hay que hacer tres pasos:
  * Ha de crearse un archivo machines con la lista de máquinas (una por línea) que van a ser usadas para ejecutar:
``` bash
cat <<EOF > machines
nodo1
nodo2
EOF
```
  * Ha de tener el ejecutable en todos los nodos (si no se tiene un directorio de cuenta compartido en las máquinas):
``` bash
scp pi nodo1:~/pi
scp pi nodo2:~/pi
```
  * Ha de lanzarse la ejecución en las máquinas deseadas usando mpirun:
``` bash
mpirun -np 2 -machinefile machines ~/pi
```
La salida será:
``` bash
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


## Bibliografía de ejemplos de MPI

* [mpi_hola.c](https://github.com/mpitutorial/mpitutorial/tree/gh-pages/tutorials/mpi-hello-world/code)
* [pi.c](https://www.mcs.anl.gov/research/projects/mpi/tutorial/mpiexmpl/src/pi/C/main.html)
* [llamadas colectivas](https://github.com/mpitutorial/mpitutorial/tree/gh-pages/tutorials/mpi-broadcast-and-collective-communication)


## Agradecimientos

Por último pero no por ello menos importante, agradecer al personal del Laboratorio del Departamento de Informática toda la ayuda prestada para que este laboratorio sea posible.


