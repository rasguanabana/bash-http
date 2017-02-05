#!/bin/bash

for f in lib/*; do
    source "$f"
done

connection.serve
