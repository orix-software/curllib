.include "curl.inc"
.include "telestrat.inc"

.export curl_parse_url

.import inet_aton

.proc  curl_parse_url
    curl_struct_ptr := RES
    curl_current_ptr_arg := RESB

    curl_bkp_offset_src := HRS1
    curl_bkp_offset_dest := HRS2

    ldy     #curl_struct::hostname
    sty     curl_bkp_offset_dest

    ; store now
    ldy     #$00

@parse_url:
    lda     (curl_current_ptr_arg),y
    beq     @finished_parsing_url
    cmp     #'/'
    beq     @uri_found
    cmp     #':'
    beq     @port_found

    sty     curl_bkp_offset_src

    ldy     curl_bkp_offset_dest
    sta     (curl_struct_ptr),y
    inc     curl_bkp_offset_dest

    ldy     curl_bkp_offset_src
    iny
    jmp     @parse_url


@port_found:
@uri_found:
    iny
    sty     curl_bkp_offset_src

    ldy     curl_bkp_offset_dest
    lda     #$00
    sta     (curl_struct_ptr),y
    sta     curl_bkp_offset_dest

    ldy     #curl_struct::uri
    sty     curl_bkp_offset_dest

@parse_uri:
    ldy     curl_bkp_offset_src
    cpy     #curl_struct::uri+CURL_MAX_LENGTH_URI  ; Overflow then stop
    beq     @finished_parsing_url

    lda     (curl_current_ptr_arg),y
    beq     @finished_parsing_url

    inc     curl_bkp_offset_src

    ldy     curl_bkp_offset_dest
    sta     (curl_struct_ptr),y
    inc     curl_bkp_offset_dest

    jmp     @parse_uri


@finished_parsing_url:
    ldy     curl_bkp_offset_dest
    lda     #$00
    sta     (curl_struct_ptr),y

    rts
.endproc
