#!/bin/bash
set -x

sudo apt-get update
sudo apt-get install -y libmpich-dev libmpich12 mpich mpich-doc
sudo apt-get clean

