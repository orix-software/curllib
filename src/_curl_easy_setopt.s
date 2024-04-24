.include "telestrat.inc"


.export _curl_easy_setopt

.import curl_easy_setopt

.importzp ptr1

.import popax
.import popa

.proc _curl_easy_setopt
    ;;@brief CURLcode curl_easy_setopt(CURL *handle, CURLoption option, void parameter);
    ;;@inputA Low struct curl ptr
    ;;@inputX High struct curl ptr
    ;;@inputY CURLOPT_URL
    ;;@inputMEM_RES  parameter
    ; Save parameter

    sta     RES
    stx     RES+1

    jsr     popa
    sta     TR0

    jsr     popax
    ; Contains curl handle

    ldy     TR0

    jmp     curl_easy_setopt
.endproc
