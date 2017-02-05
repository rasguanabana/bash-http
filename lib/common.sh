#!/bin/bash

backtrace() {
    # Shows backtrace.
    # Arguments:
    #  $* - Error message

    echo "Backtrace:"
    for ((index="${#FUNCNAME[@]}"; index > 0; index--)); do
        if [ "${BASH_SOURCE[$index]+x}" != 'x' ]; then
            continue
        fi
        echo "In file ${BASH_SOURCE[$index]}:"
        echo "  function '${FUNCNAME[$index]}' on line ${BASH_LINENO[$((index-1))]}"
    done
    echo "$*"
}

assert_vars() {
    # Assert that variables are defined
    # Arguments:
    #  $@ - List of variables to check

    for var; do
        if [ "${!var+is_set}" != 'is_set' ]; then
            backtrace "'$var' is not defined"
            return 1
        fi
    done
}
