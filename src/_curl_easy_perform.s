.export _curl_easy_perform

.import curl_easy_perform

.proc _curl_easy_perform
    ;;@proto CURLcode curl_easy_perform(CURL *easy_handle);
    ;;@brief Performs curl
    jmp     curl_easy_perform
.endproc
