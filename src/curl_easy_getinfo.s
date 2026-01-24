.include "telestrat.inc"
.include "curl.inc"

.export curl_easy_getinfo


.proc curl_easy_getinfo
    ;;@brief get infos from curl ressource
    ;;@inputA Low ptr of curl ressource
    ;;@inputX High ptr of curl ressource
    ;;@inputY Curl info to get ex : CURLINFO_PROTOCOL or CURLINFO_PRIMARY_PORT etc
    ;;@modifyMEM_RES
    ;;@modifyMEM_RESB 2 bytes (for output ptr)
    ;;@modifyMEM_TR0
    ;;@modifyMEM_TR2 2 bytes
    ;;@```asm
    ;;@` lda ptr_parameter_low ; ptr to parameter
    ;;@` sta RESB ; ptr to parameter
    ;;@` lda ptr_parameter_high ; ptr to parameter
    ;;@` sta RESB + 1 ; ptr to parameter
    ;;@` lda curl_handle_low ; ptr to curl handle
    ;;@` ldx curl_handle_high ; ptr to curl handle
    ;;@` ldy CURLINFO_PROTOCOL ; info to get
    ;;@` jsr curl_easy_cleanup
    ;;@` rts
    ;;@```
    ;;@note for CURLINFO_SCHEME, the parameter must be already allocated with enough space to store the string : 7 bytes
    ;;@note for CURLINFO_PRIMARY_IP, the parameter must be already allocated with enough space to store the string : eg : 16 bytes (xxx.xxx.xxx.xxx + null terminator)
    ;;@note returns CURLE_OK if ok, CURLE_UNKNOWN_OPTION if option unknown

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

    cpy     #CURLINFO_HOST
    beq     @curlinfo_hostname_extract

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

    lda     #CURLE_OK

    rts

@curlinfo_hostname_extract:

    ; Compute the ptr for hostname
    jsr     init_ptr

.IFPC02
    stz     tmp16 + 1
.else
    lda     #$00
    sta     tmp16 + 1
.endif

    ldy     #curl_struct::hostname

@L2:
    lda     (curl_res),y ; 5774

    beq     @end_scheme_copy
    sty     tmp16
    ldy     tmp16 + 1
    sta     (TR0),y
    inc     tmp16 + 1
    ldy     tmp16
    iny
    bne     @L2
    lda     #CURLE_OK

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
