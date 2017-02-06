#!/bin/bash

processor.get_handler() {
    # Handle GET
    # Arguments:
    #  $1 - Request URI

    local uri="$1"
    declare -A request_headers
    if ! parser.headers; then
        logging.error "No headers"
        bh_ecode=400 respond
        return 1
    fi
    echo "${request_headers[host]}"
}

processor.process() {
    # Main function for handling a single connection

    local close=false
    while ! $close; do
        if ! parser.request; then
            respond
            break
        fi

        # validate protocol
        case $request_proto in
            'HTTP/1.0'|'HTTP/1.1')
                ;;
            *)
                bh_ecode=400 respond
                break
                ;;
        esac

        case "$request_method" in
            GET)
                processor.get_handler "$request_uri"
                ;;
            HEAD)
                processor.head_handler "$request_uri"
                ;;
            *)
                bh_ecode=400 respond
                break
                ;;
        esac
    done
}
