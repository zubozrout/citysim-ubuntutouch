#!/bin/bash

# Switch to current directory
cd "${0%/*}"
# Delete build data
clickable clean
# Build the project
clickable build
# Package a .click
clickable click-build
# Review the final package
clickable review
