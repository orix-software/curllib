.export _curl_easy_init

.import curl_easy_init


.importzp tmp1

.proc _curl_easy_init
    ;;@proto CURL *curl_easy_init();
    ;;@brief init curl session and returns the initialization of the curl object
    ;;@note Set default protocol to HTTP and default port to 80, hostname and uri to empty string, ip to 0.0.0.0
    ;;@```code
    ;;@`  main() {
    ;;@`  CURL *curl;
    ;;@`  curl = curl_easy_init();
    ;;@`  curl_easy_cleanup(curl);
    ;;@` }
    ;;@```
    jsr     curl_easy_init

.IFPC02
    tyx
.else
    ; FIXME 65C02
    sty     tmp1
    ldx     tmp1
.endif
    rts
.endproc
