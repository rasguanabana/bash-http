#!/bin/bash

worker.spawn() {
    # Main function for handling a single connection

    echo -n "Hello"
    sleep 5
    echo " World!"
    return 0

    local close=False
    while ! $close; do
        parser.request
        parser.headers
        parser.body
    done
}
export -f worker.spawn
