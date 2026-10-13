#!/bin/bash
set -x

## Install *MPI* software
sudo aptitude install mpich libmpich-dev -y

pushd .

cd /tmp/
wget https://launchpad.net/ubuntu/+source/mpich/4.2.0-5.1/+build/28285882/+files/libmpich12_4.2.0-5.1_amd64.deb
wget https://launchpad.net/ubuntu/+source/mpich/4.2.0-5.1/+build/28285882/+files/mpich_4.2.0-5.1_amd64.deb
wget https://launchpad.net/ubuntu/+source/mpich/4.2.0-5.1/+build/28285882/+files/libmpich-dev_4.2.0-5.1_amd64.deb

sudo dpkg -i  *.deb

popd

