#!/bin/bash

mkdir -p ~/.local/{bin,etc}
rsync -avPh ./bin/* ~/.local/bin/
rsync -avPh ./etc/* ~/.local/etc/
