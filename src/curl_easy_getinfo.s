.include "telestrat.inc"
.include "curl.inc"

.export curl_easy_getinfo

.proc curl_easy_getinfo
    ;;@brief get infos from curl ressource
    ;;@inputA Low ptr of curl ressource
    ;;@inputX High ptr of curl ressource
    ;;@inputY Curl info to get ex : CURLINFO_PROTOCOL or CURLINFO_PRIMARY_PORT etc
    ;;@modifyMEM_RES
    ;;@modifyMEM_RESB 2 bytes
    ;;@modifyMEM_TR0
    ;;@modifyMEM_TR2 2 bytes

    curl_res        := RES
    curl_info       := TR0
    tmp16           := TR2
    get_info_output := RESB ; 2 bytes

    ; curl res
    sta     curl_res
    stx     curl_res + 1
    sty     curl_info

    cpy     #CURLINFO_PROTOCOL
    beq     @curlinfo_protocol_extract

    cpy     #CURLINFO_PRIMARY_PORT
    beq     @curlinfo_primary_port_extract

    ; CURLINFO_SCHEME returns the URL scheme (protocol) name "http", "https", "ftp", etc.
    cpy     #CURLINFO_SCHEME
    beq     @curlinfo_scheme_extract

    lda     #CURLE_UNKNOWN_OPTION

    rts

@curlinfo_protocol_extract:
    ldy     #curl_struct::protocol
    lda     (curl_res),y

    ldy     #$00
    sta     (get_info_output),y
    lda     CURLE_OK

    rts

@curlinfo_primary_port_extract:
    ldy     #curl_struct::dest_port

    lda     (curl_res),y

    ldy     #$00
    sta     (get_info_output),y

    ldy     #curl_struct::dest_port + 1
    lda     (curl_res),y
    ldy     #$01
    sta     (get_info_output),y

    lda     CURLE_OK

    rts

@curlinfo_scheme_extract:

    ldy     #curl_struct::protocol
    lda     (curl_res),y
    tay

    lda     curl_ptr_string_low,y
    sta     curl_res

    lda     curl_ptr_string_high,y
    sta     curl_res + 1

    jsr     init_ptr

    ldy     #$00
@L1:
    lda     (curl_res),y
    beq     @end_scheme_copy
    sta     (TR0),y
    iny
    bne     @L1


@end_scheme_copy:
    lda     #$00
    sta     (TR0),y


    lda     CURLE_OK

    rts

init_ptr:
    ldy     #$00
    lda     (get_info_output),y
    sta     TR0
    iny
    lda     (get_info_output),y
    sta     TR0 + 1
    rts

.endproc

