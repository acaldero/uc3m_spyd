# Sistemas Paralelos y Distribuidos

&nbsp;&nbsp; [![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL_v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Curso-2025_2026-red.svg)
&nbsp; ![Curso 2025-2026](https://img.shields.io/badge/Autores-Alejandro%20Calderon%20Mateos%20y%20Felix%20Garcia%20Carballeira-brown.svg)


## Laboratorio sobre soporte para tolerancia a fallos en Sistemas Distribuidos

* Máquinas de trabajo:
  * [Sistema dedicado en la nube cloud.lab.inf.uc3m.es](https://github.com/acaldero/uc3m_spyd/blob/main/materiales/INFO_cloud.md)
    * [Pre-requisitos para trabajar en ssddX.cloud.lab.inf.uc3m.es](/materiales/INFO_cloud.md#11-pre-requisitos-para-trabajar-en-ssddxcloudlabinfuc3mes)
    * [Conexión SSH con las máquinas de trabajo](/materiales/INFO_cloud.md#12-conexi%C3%B3n-ssh-con-las-m%C3%A1quinas-de-trabajo)
  * [Sistema propio usando contenedores docker](https://github.com/acaldero/uc3m_spyd/blob/main/materiales/INFO_docker.md)
    * [Pre-requisitos para trabajar con contenedores](/materiales/INFO_docker.md#11-pre-requisitos-para-trabajar-con-contenedores)
    * [Conexión SSH con las máquinas de trabajo](/materiales/INFO_docker.md#12-conexi%C3%B3n-ssh-con-las-m%C3%A1quinas-de-trabajo)

* Software necesario:
  * [Instalación de Python](#3-instalación-de-python)

* Ejemplos para aprender:
  * [Checkpointing](#31-checkpointing)



## Software necesario

### Instalación de Python

<html>
<table>

<tr>
<td></td>
<td>Uso de PIP</td>
<td>Uso de Anaconda</td>
</tr>

<tr>
<td>Instalar Python3</td>
<td>
<small><pre>
sudo apt-get install \
     python3-minimal python3-pip
</pre></small>
</td>
<td>
<pre>
wget <sub>https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh</sub>
chmod a+x Anaconda3-2023.09-0-Linux-x86_64.sh
./Anaconda3-2023.09-0-Linux-x86_64.sh -b
source ~/.profile
conda update --all
conda clean  --all
</pre>
</td>
</tr>

</table>
</html>


No obstante para los ejemplos se usará PIP.


## Ejemplos para aprender

### Checkpointing

#### Preparación

Si no tiene el directorio *lab_checkpoint* entonces precisa ejecutar:
```
git clone https://github.com/acaldero/uc3m_spyd.git
cd uc3m_spyd/materiales
```
Si tiene el directorio *lab_checkpoint* entonces hay que introducir:
```
cd lab_checkpoint
chmod a+x *.sh
```


#### Ejecutar el ejemplo

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


