.include "curl.inc"

.export curl_version

curl_version_str:
    .asciiz "2026.1"

.proc curl_version
    ;;brief returns curl version
    lda     #<curl_version_str
    ldx     #>curl_version_str

    rts
.endproc
