# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Sistema propio usando contenedores docker


### 1. Pre-requisitos para trabajar con contenedores

Ha de disponer de:
1. Instalar Docker Desktop en su ordenador.
2. Ha de usar el contenedor facilitado en el repositorio.

Como ayuda:
1. Para instalar Docker Desktop siga los pasos en: https://www.docker.com/products/docker-desktop/


### 2. Conexión SSH con las máquinas de trabajo

* Para conectar al contendor X, siendo X = {0, 1, ... 8}:
```
./docker.sh start 8
./docker.sh bash X
...
```

* Una vez que finalice su sesión de trabajo, ha de cerrar la sesión abierta usando el mandato exit:
```
exit
./docker.sh stop
```

