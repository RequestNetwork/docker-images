#!/bin/bash

find . -type d -maxdepth 2 -name build -exec node {} \;
