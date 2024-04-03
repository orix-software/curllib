.include "telestrat.inc"

.export curl_easy_cleanup

.proc curl_easy_cleanup
    ;;@brief free ressources
    ;;@inputA Low ptr
    ;;@inputX High ptr
    BRK_TELEMON XFREE
    rts
.endproc
