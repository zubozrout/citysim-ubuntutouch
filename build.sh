#!/bin/bash

# Switch to current directory
cd "${0%/*}"
# Delete build data
clickable clean
# Build the project
clickable build -a armhf
clickable build -a arm64
clickable build -a amd64
