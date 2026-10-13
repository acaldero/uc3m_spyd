#!/bin/bash
set -x

## Install *MPI* software
#
wget https://launchpad.net/ubuntu/+source/mpich/4.2.0-5.1/+build/28285882/+files/libmpich12_4.2.0-5.1_amd64.deb
wget https://launchpad.net/ubuntu/+source/mpich/4.2.0-5.1/+build/28285882/+files/mpich_4.2.0-5.1_amd64.deb
wget https://launchpad.net/ubuntu/+source/mpich/4.2.0-5.1/+build/28285882/+files/libmpich-dev_4.2.0-5.1_amd64.deb

dpkg -i  libmpich12_4.2.0-5.1_amd64.deb  mpich_4.2.0-5.1_amd64.deb  libmpich-dev_4.2.0-5.1_amd64.deb

