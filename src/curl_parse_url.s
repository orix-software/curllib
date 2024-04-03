.include "curl.inc"
.include "telestrat.inc"

.export curl_parse_url


.import inet_aton

.proc  curl_parse_url
    ; RES must contains struct
    ; Use TR0
    ; Use TR1

    ldy     #curl_struct::url

@search_protocol:
    lda     (RES),y
    beq     @end_parse_url
    cmp     #':'
    beq     @looking_for_protocol
    iny
    cpy     #$05+curl_struct::url
    beq     @is_a_not_protocol
    bne     @search_protocol


@is_a_not_protocol:
    ; at this step we guess that there is no protocol, and it means that it's http. Cut hostname then

    lda     #curl_struct::hostname
    sta     TR0

    ldy     #curl_struct::url

@L13:
    lda     (RES),y
    beq     @finished_parsing_hostname
    cmp     #':'
    beq     @finished_parsing_hostname
    cmp     #'/'
    beq     @finished_parsing_hostname

    sty     TR1

    ldy     TR0
    sta     (RES),y
    inc     TR0

    ldy     TR1
    iny
    cpy     #curl_struct::url+CURL_MAX_LENGTH_URL
    bne     @L13

    ; url is checked in setopt already

@finished_parsing_hostname:
    sty     TR1 ; Save pos
    ; ADD EOS hostname
    ldy     TR0
    lda     #$00
    sta     (RES),y

    ldy     TR1
    lda     (RES),y
    cmp     #$00
    beq     @end_parse_url
    cmp     #':'
    beq     @check_port
    cmp     #'/'
    beq     @check_uri

@check_port:
    lda     #curl_struct::dest_port
    sta     TR0

@loop_check_port:
    iny
    lda     (RES),y
    beq     @end_port
    cmp     #'/'
    beq     @end_port
    cmp     #'0'
    bcc     @error_port
    cmp     #':'
    bcs     @error_port
    sty     TR1
    ldy     TR0
    sta     (RES),y
    inc     TR0
    ldy     TR1
    jmp     @loop_check_port

@end_port:
    sty     TR1
    ldy     TR0
    lda     #$00
    sta     (RES),y ; set ascii port ... FIXME
    ldy     TR1
    jmp     @finished_parsing_hostname

@end_parse_url:
    lda     #CURLE_OK
    rts

@looking_for_protocol:
    jsr     curl_search_protocol
    cmp     #$00 ; OK
    beq     @is_a_not_protocol
    ; Protocol error
    lda     #CURLE_UNSUPPORTED_PROTOCOL
    rts

@check_uri:
    lda     #curl_struct::uri
    sta     TR0
    ldy     TR1

@loop_check_uri:
    iny
    lda     (RES),y
    beq     @end_uri
    sty     TR1
    ldy     TR0
    sta     (RES),y
    inc     TR0
    ldy     TR1
    jmp     @loop_check_uri

@end_uri:


    ldy     TR0
    sta     (RES),y
    jmp     @end_parse_url

@error_port:
    lda     #CURLE_RANGE_ERROR
    rts


.endproc

.proc curl_search_protocol
    ; Returns 0 if protocol found
    ; returns 1 if protocol is not found
    ; Y contains the first char after :// if protocol is found
    ldy     #curl_struct::url
    ldx     #$00

@L1_search_protocol:
    lda     (RES),y
    cmp     #':'
    beq     @validate
    cmp     supported_protocol_str,x
    bne     @protocol_not_supported
    iny
    inx
    bne     @L1_search_protocol

@validate:
    iny
    lda     (RES),y
    cmp     #'/'
    bne     @protocol_not_supported
    iny
    lda     (RES),y
    cmp     #'/'
    bne     @protocol_not_supported
    iny
    lda     #CURLE_OK

    rts

@protocol_not_supported:
    ldy     #curl_struct::protocol
    sta     (RES),y
    lda     #$01
    rts

supported_protocol_str:
    .asciiz "http"

supported_protocol_mapping:
    .byt    <CURL_PROTOCOL_HTTP
.endproc
