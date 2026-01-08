.include "telestrat.inc"

.export curl_easy_cleanup

.proc curl_easy_cleanup
    ;;@brief free curl ressources
    ;;@inputA Low ptr of curl ressources
    ;;@inputX High ptr of curl ressources
    BRK_TELEMON XFREE
    rts
.endproc
