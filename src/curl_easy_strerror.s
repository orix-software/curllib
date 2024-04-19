.export curl_easy_strerror
.include "telestrat.inc"

.proc curl_easy_strerror

    tay
    lda     error_tab_high,y
    tax
    lda     error_tab_low,y
    rts

error_tab_low:
    .byt <str_CURLE_OK
    .byt <str_CURLE_UNSUPPORTED_PROTOCOL
    .byt <str_CURLE_COULDNT_CONNECT
    .byt <str_CURLE_RANGE_ERROR
    .byt <str_CURLE_UNKNOWN_OPTION
    .byt <str_CURLE_TOO_LARGE

error_tab_high:
    .byt >str_CURLE_OK
    .byt >str_CURLE_UNSUPPORTED_PROTOCOL
    .byt >str_CURLE_COULDNT_CONNECT
    .byt >str_CURLE_RANGE_ERROR
    .byt >str_CURLE_UNKNOWN_OPTION
    .byt >str_CURLE_TOO_LARGE

str_CURLE_OK:
    .asciiz "OK" ; No error
str_CURLE_UNSUPPORTED_PROTOCOL:
    .asciiz "Unsupported protocol"
str_CURLE_COULDNT_CONNECT:
    .asciiz "Could not connect"
str_CURLE_RANGE_ERROR:
    .asciiz "Range Error"
str_CURLE_UNKNOWN_OPTION:
    .asciiz "Unknown option"
str_CURLE_TOO_LARGE:
    .asciiz "Too large"

.endproc
