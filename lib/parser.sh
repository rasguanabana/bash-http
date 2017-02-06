#!/bin/bash

parser.request() {
    # Parse request line by processing standard input

    assert_vars parser_timeout

    if ! read -r -t "${parser_timeout}" request_line; then
        logging.error -n "read operation timed out"
        bh_ecode=110
        return 1
    fi

    # get rid of CR
    request_line="${request_line/$'\r'/}"

    request_tokens=($request_line)
    if [ ${#request_tokens[@]} -ne 3 ]; then
        logging.error "Request line malformed"
        bh_ecode=400
        return 1
    fi

    # assign parts to corresponding names
    request_method="${request_tokens[0]}"
    request_uri="${request_tokens[1]}"
    request_proto="${request_tokens[2]}"
}

parser.headers() {
    # Parse request headers.
    # Requires:
    #  requests_headers - declared as an associative array

    # this is needed in order to return headers to caller.
    assert_assoc_array request_headers

    while read -r -t "${parser_timeout}" header; do
        header="$header"$'\n'
        case "$header" in
            *': '*$'\n')
                local header_name="${header%%': '*}"
                local header_value="${header#*': '}"
                request_headers["${header_name/$'\n'/}"]="${header_value/$'\n'/}"
                ;;
            $'\n')
                break
                ;;
        esac
    done
    [ ${#request_headers[@]} -ne 0 ] # return code of this will be return code of the function
}
