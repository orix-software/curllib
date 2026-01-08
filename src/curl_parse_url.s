.include "curl.inc"
.include "telestrat.inc"

.include "../dependencies/orix-sdk/macros/SDK_misc.mac"

.export curl_parse_url


.proc  curl_parse_url
    ; RES must contains struct,and RES content is not modifyed
    ; Use TR0
    ; Use TR1
    ; Use TR2
    ; Use TR3
    ; Use TR4
    ; Use TR5
    ; Use TR6
    ; Use TR7

    is_an_ip := TR6
    digit_ip := TR7 ; used to count digit in ip
    rts

    lda     #$00
    sta     is_an_ip
    sta     digit_ip

    ; check if url is an ip address

    ldy     #curl_struct::url

; Looking for http, https, ftp, ftps, sftp but only http works

@search_protocol:

    lda     (RES),y
    beq     @end_parse_url
    cmp     #':'
    beq     @looking_for_protocol
    iny
    cpy     #$06 + curl_struct::url ; 6 because we can not have a protocol longer than 6 letters (telnet for example)
    bne     @search_protocol


@is_a_not_protocol:
    ; at this step we know that there is no protocol, and it means that it's http. Cut hostname then

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

; @isdigit:
;     cmp     #'0'         ; Comparer avec '0'
;     bcc     @not_digit    ; Si A < '0', ce n'est pas un chiffre
;     cmp     #'9' + 1       ; Comparer avec '9' + 1
;     bcs     @not_digit    ; Si A >= '9' + 1, ce n'est pas un chiffre
;     ; Si nous arrivons ici, c'est un chiffre
;     rts              ; Retourner avec Z défini

; @not_digit:
;     ; Defines if it's not ip address
;     ldx     #$01
;     stx     is_an_ip


@continue:

    sty     TR1

    ldy     TR0
    sta     (RES),y
    inc     TR0

    ldy     TR1
    iny
    cpy     #curl_struct::url + CURL_MAX_LENGTH_URL
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
    ; Store first position of the port
    ; ex : http://www.oric.org:443
    ;                         |
    sty     TR0
    ; and inc to set to the first number of the port
    ; ex : http://www.oric.org:443
    ;                          |
    inc     TR0

    ldx     #$00
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
    inx
    cpx     #$05
    beq     @error_port
    ;sty     TR1
    ;ldy     TR0
    ;sta     (RES),y
    ;inc     TR0
    ;ldy     TR1

    jmp     @loop_check_port

@end_port:
    ; XDECAY Modify RES and RESB !
    jmp     @compute_port

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

@compute_port:
    sty     TR1
    lda     RES+1
    sta     TR2+1
    ; Compute the offset of the number
    lda     TR0
    clc
    adc     RES
    bcc     @S3
    inc     TR2
@S3:
    sta     TR2
    ; At this step TR2 (and TR3) are set here (ptr):
    ; ex : http://www.oric.org:443
    ;                          |

    ldy     TR1
    lda     (RES),y
    sta     TR0 ; Save the char under  the char after the port
    lda     #$00
    sta     (RES),y ; Store 0

    lda     RES
    sta     TR4
    lda     RES+1
    sta     TR4+1

    lda     TR2
    ldy     TR3
    BRK_TELEMON XDECAY  ; Modify RES and RESB
    ; A and Y contains the 16 bits value
    ; Save
    sta     TR2
    sty     TR3
    ; Restore RES
    lda     TR4
    sta     RES
    lda     TR4+1
    sta     RES+1


    ; Restore value in url
    ldy     TR1
    lda     TR0
    sta     (RES),y

    ldy     #curl_struct::dest_port
    lda     TR2
    sta     (RES),y
    iny
    lda     TR3
    sta     (RES),y


    ldy     TR1
    jmp     @finished_parsing_hostname

.endproc

.proc curl_search_protocol
    ; Returns 0 if protocol found
    ; returns 1 if protocol is not found
    ; Y contains the first char after :// if protocol is found
    ;jmp     curl_search_protocol



.endproc
