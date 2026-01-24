.include "telestrat.inc"

.export _curl_easy_setopt

.import curl_easy_setopt

.importzp ptr1


.import popax
.import popa

.proc _curl_easy_setopt
    ;;@proto CURLcode curl_easy_setopt(CURL *handle, CURLoption option, void parameter);
    ;;@brief set opt for curl object (Ex : res = curl_easy_setopt(curl, CURLOPT_URL, "http://example)
    ;;@param handle: The curl handle
    ;;@param option: The option to set
    ;;@param parameter: The parameter for the option
    ;;@return CURLcode: Returns CURLE_OK if the option was set successfully, or CURLE_UNKNOWN_OPTION if the option is not recognized.
    ;;@```code
    ;;@`  main() {
    ;;@`  CURL *curl;
    ;;@`  char *url = "http://192.168.1.77:80/10K.htm";
    ;;@`  curl = curl_easy_init();
    ;;@`  res = curl_easy_setopt(curl, CURLOPT_URL, url);
    ;;@`  curl_easy_cleanup(curl);
    ;;@` }
    ;;@```

    sta     RES ; store parameter
    stx     RES + 1

    jsr     popa    ; Get curl option
    sta     TR0

    jsr     popax
    ; Contains curl handle

    ldy     TR0

    jmp     curl_easy_setopt
.endproc
