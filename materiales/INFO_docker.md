# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Sistema propio usando contenedores docker


### 1. Pre-requisitos para trabajar con contenedores

Ha de disponer de:
1. Instalar Docker Desktop en su ordenador ([linux](https://docs.docker.com/desktop/setup/install/linux/), [windows](https://docs.docker.com/desktop/setup/install/windows-install/) or [mac](https://docs.docker.com/desktop/setup/install/mac-install/)).
   * Para instalar Docker Desktop siga los pasos en: https://www.docker.com/products/docker-desktop/
   * Disponible para [linux](https://docs.docker.com/desktop/setup/install/linux/), [windows](https://docs.docker.com/desktop/setup/install/windows-install/) or [mac](https://docs.docker.com/desktop/setup/install/mac-install/).
2. Puede usar la configuración facilitada en el repositorio.
   * Ha de construir la imagen del contenedor usando:
   ```
   ./docker.sh build
   ```


### 2. Conexión SSH con las máquinas de trabajo

* Ha de crear al menos 3 contenedores a partir de la imagen usando:
  ```
  ./docker.sh start 3
  ```

* Para conectar al contendor X, siendo X = {1, ... 3}, y trabajar en el:
  ```
  ./docker.sh bash X
  ...
  ```

* Una vez que finalice su sesión de trabajo, ha de cerrar la sesión abierta usando el mandato exit:
  ```
  exit
  ```

* Para parar los contenedores creados ha de usar:
  ```
  ./docker.sh stop
  ```

