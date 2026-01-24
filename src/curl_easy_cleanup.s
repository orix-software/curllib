.include "telestrat.inc"

.export curl_easy_cleanup


.proc curl_easy_cleanup
    ;;@brief free curl ressources
    ;;@inputA Low ptr of curl ressources
    ;;@inputX High ptr of curl ressources
    ;;@```asm
    ;;@` lda curl_handle_low ; ptr to curl handle
    ;;@` ldx curl_handle_high ; ptr to curl handle
    ;;@` jsr curl_easy_cleanup
    ;;@` rts
    ;;@```
    BRK_TELEMON XFREE
    rts
.endproc
