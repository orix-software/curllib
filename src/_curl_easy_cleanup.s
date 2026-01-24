.export _curl_easy_cleanup

.import curl_easy_cleanup

.importzp tmp1

.proc _curl_easy_cleanup
    ;;@brief void curl_easy_cleanup(CURL *handle);
    ;;@param handle The CURL handle to clean up. (This function is used to clean up a CURL handle that was previously initialized with curl_easy_init().)
    ;;@return void
    ;;@note This function should be called when the handle is no longer needed to free up resources.
    ;;@note This function is a no-op if the handle is NULL.
    ;;@```code
    ;;@`  main() {
    ;;@`  CURL *curl;
    ;;@`  curl = curl_easy_init();
    ;;@`  curl_easy_cleanup(curl);
    ;;@` }
    ;;@```
    ; FIXME 65C02
.IFPC02
    txy
.else
    stx     tmp1
    ldy     tmp1
.endif
    jmp     curl_easy_cleanup
.endproc
