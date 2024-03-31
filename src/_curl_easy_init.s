.export _curl_easy_init

.import curl_easy_init

.importzp tmp1

.proc _curl_easy_init
    ;;@proto CURL *curl_easy_init();

    jsr     curl_easy_init
    ; FIXME 65C02
    sty     tmp1
    ldx     tmp1
    rts
.endproc
