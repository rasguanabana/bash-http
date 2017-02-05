#!/bin/bash

connection.serve() {
    # Start serving. This function obtains parameters
    # From configuration variables.

    # assert that needed variables are defined.
    # connection_port is not used here, but needed by variable which holds backend options, hence it is checked here.
    assert_vars \
        connection_server_entry \
        connection_backend \
        connection_port
    local _backend_opts="${connection_backend}_opts"
    local _backend_exec_pre="${connection_backend}_exec_pre"
    local _backend_exec_post="${connection_backend}_exec_post"
    assert_vars "$_backend_opts" "${_backend_exec_pre}" "${_backend_exec_post}"

    # spawn server, e.g. socat TCP4-LISTEN:8080,fork EXEC:"bash -c 'worker.spawn'"
    "$connection_backend" "${!_backend_opts}" "${!_backend_exec_pre}""$connection_server_entry""${!_backend_exec_post}"
}
