.export _curl_version

.import curl_version


.proc _curl_version
    ;;@proto char    *curl_version();
    ;;@brief get curl version
    jmp     curl_version
.endproc
