.include "telestrat.inc"

.export _curl_easy_getinfo

.import curl_easy_getinfo

.import popax
.import popa
.importzp ptr1
.importzp ptr2


.proc _curl_easy_getinfo
    ;;@proto CURLcode curl_easy_getinfo(CURL *curl, CURLINFO info, ... );
    ;;@brief Get info from curl

    ; Ex : res = curl_easy_getinfo(res, CURLINFO_PROTOCOL, &protocol);

    ; Exemple : protocol

    sta     RESB
    stx     RESB + 1

    ; CURLINFO
    jsr     popa

    sta     ptr2

    jsr     popax
    ; A & X contains ptr

    ldy     ptr2
    jmp     curl_easy_getinfo

    ; pha

    ; lda     RESB
    ; sta     ptr1
    ; ;ldy     #$00
    ; ;sta     (ptr1),y

    ; lda     RESB + 1
    ; sta     ptr1 + 1
    ; ;iny
    ; ;sta     (ptr1),y
    ; pla


.endproc

