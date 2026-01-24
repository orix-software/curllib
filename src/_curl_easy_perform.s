.export _curl_easy_perform

.import curl_easy_perform

.proc _curl_easy_perform
    ;;@proto CURLcode curl_easy_perform(CURL *easy_handle);
    ;;@brief Performs curl
    ;;@failure doest not work yet
    ;;@param easy_handle: The curl handle
    ;;@return CURLcode: Returns CURLE_OK if the operation was successful.
    jmp     curl_easy_perform
.endproc
