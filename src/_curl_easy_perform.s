.export _curl_easy_perform

.import curl_easy_perform

.proc _curl_easy_perform
    ;;@brief CURLcode curl_easy_perform(CURL *easy_handle);
    jmp     curl_easy_perform
.endproc
