#!/bin/bash

set -a
# all vars will be automatically exported
for f in lib/*; do
    source "$f"
done
set +a

connection.serve
