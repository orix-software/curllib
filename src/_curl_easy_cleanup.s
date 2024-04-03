.export _curl_easy_cleanup

.import curl_easy_cleanup

.importzp tmp1

.proc _curl_easy_cleanup
    ;;@brief void curl_easy_cleanup(CURL *handle);
    ; FIXME 65C02
    stx     tmp1
    ldy     tmp1
    jmp     curl_easy_cleanup
.endproc
