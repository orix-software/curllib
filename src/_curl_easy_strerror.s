.export _curl_easy_strerror

.import curl_easy_strerror

.proc _curl_easy_strerror
    ;;@proto const char *curl_easy_strerror(CURLcode errornum);
    ;;@brief convert errornum into str
    jmp     curl_easy_strerror

.endproc
