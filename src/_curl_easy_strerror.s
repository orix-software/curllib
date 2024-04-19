.export _curl_easy_strerror

.import curl_easy_strerror

.proc _curl_easy_strerror
    ;;@brief const char *curl_easy_strerror(CURLcode errornum);
    jmp     curl_easy_strerror

.endproc
