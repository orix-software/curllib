.export _curl_version


.import curl_version

.proc _curl_version
    ;;@proto char    *curl_version();
    ;;@brief get curl version
    ;;@```code
    ;;@`  main() {
    ;;@`  printf("Curl version: %s\n", curl_version());
    ;;@` }
    ;;@```
    jmp     curl_version
.endproc
