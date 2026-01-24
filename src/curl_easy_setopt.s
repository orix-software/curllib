.include "curl.inc"
.include "telestrat.inc"
.include "_file.inc"

.include "../dependencies/orix-sdk/macros/SDK_print.mac"

.export curl_easy_setopt

.import curl_parse_url
.import curl_print_object

.import _atoi


.proc  curl_easy_setopt
    ;;@brief Set opt
    ;;@inputA Low struct curl ptr
    ;;@inputX High struct curl ptr
    ;;@inputY CURLOPT option to set (CURLOPT_URL only handled)
    ;;@inputMEM_RES parameter
    ;;@modifyMEM_TR0 Tmp
    ;;@modifyMEM_TR2 saveY tmp
    ;;@modifyMEM_TR3 tmp
    ;;@modifyMEM_HRS tmp
    ;;@modifyMEM_RESB Ptr
    ;;@return CURLE_OK if ok, CURLE_UNKNOWN_OPTION if option unknown, CURLE_URL_MALFORMAT if url is not well formed, CURLE_TOO_LARGE if url is too long
    ;;@```asm
    ;;@  lda  parameter_low ; ptr to parameter
    ;;@  sta  RES
    ;;@  lda  parameter_high ; ptr to parameter
    ;;@  sta  RES + 1 ; ptr to parameter
    ;;@  lda  curl_handle_low ; ptr to curl handle
    ;;@  ldx  curl_handle_high ; ptr to curl handle
    ;;@  ldy  #CURLOPT_URL ; option to set
    ;;@` jsr  curl_easy_setopt
    ;;@` rts
    ;;@```
    ;;@note send CURLE_TOO_LARGE if the *url* parameter is bigger than lib curl can
    ;;@note send CURLE_TOO_LARGE if the ** parameter is bigger than lib curl can (CURL_MAX_LENGTH_URI into curl.h)
    ;;@note uses atoi from cc65 telestrat.lib instead of reimplementing it or calling it from orix kernel
    ;;@note Handles only *CURLOPT_URL* option


    ptr_parameter      := RES  ; ptr parameter
    curlopt            := TR0  ; option define
    curl_res           := RESB ; Curl resource
    save_pos_curl_res  := TR2
    search_id_protocol := TR3
    save_position_into_url := HRS1
    save_position_into_hostname := HRS1 + 1
    save_position_into_uri := HRS1 + 1

    ; RES or ptr_parameter contains parameter (3rd arg)
    ; Save

    sta     curl_res
    stx     curl_res + 1
    sty     curlopt ; Y contains CURLoption

    ; Set curl_opt in struct (only 8 options managed)
    ldy     #curl_struct::curl_opt
    lda     (curl_res),y
    eor     curlopt
    sta     (curl_res),y

    lda     curlopt
    cmp     #CURLOPT_VERBOSE
    beq     @verbose_option

    cmp     #CURLOPT_WRITEDATA
    beq     @write_data_option

    cmp     #CURLOPT_DRYRUN
    beq     @dryrun_option

    cmp     #CURLOPT_URL
    beq     @url_option

    ; Unknown option
    lda     #CURLE_UNKNOWN_OPTION
    rts

@write_data_option:
    ; store fp

    lda     RES
    beq     @disable_write_data_option

    lda     #curl_struct::curl_opt
    lda     (curl_res),y
    ora     #CURLOPT_WRITEDATA
    sta     (curl_res),y

@set_fp:
    ldy     #_FILE::f_fd
    lda     (curl_res),y        ; file->f_fd = fd;

    ldy     #curl_struct::curl_opt_ptr
    sta     (ptr_parameter),y

    lda     #CURLE_OK
    rts

@disable_write_data_option:
    lda     #curl_struct::curl_opt
    lda     (curl_res),y
    eor     #CURLOPT_WRITEDATA
    sta     (curl_res),y
    lda     #CURLE_OK
    rts

@verbose_option:
    lda     #CURLE_OK
    rts

@dryrun_option:
    lda     #curl_struct::curl_opt
    lda     (curl_res),y
    and     #CURLOPT_VERBOSE
    cmp     #CURLOPT_VERBOSE
    bne     @not_verbose_dryrun

@not_verbose_dryrun:
    lda     #CURLE_OK
    rts


; ##############################################################
; #                   url option                               #
; ##############################################################


@url_option:

    ; Set default http protocol

    lda     #CURLPROTO_HTTP
    ldy     #curl_struct::protocol
    sta     (curl_res),y
    tax
    lda     mapping_protocol_port_dest_low,x
    ldy     #curl_struct::dest_port
    sta     (curl_res),y

    lda     mapping_protocol_port_dest_high,x
    iny
    sta     (curl_res),y

    ; Detect if a ptrocol is present (http:// ...)

    ldy     #$00
    sty     save_position_into_url  ; Store offset position of url
@L3:
    lda     (ptr_parameter),y
    beq     @no_protocol ; No protocol found
    cmp     #':'
    beq     @validate_protocol
    iny
    cpy     #CURL_MAX_LENGTH_URL
    bne     @L3

    lda     #CURLE_TOO_LARGE
    rts

@validate_protocol:
    iny
    lda     (ptr_parameter),y
    cmp     #'/' ; Check for port or protocol
    bne     @no_protocol ; or is a port
    iny
    lda     (ptr_parameter),y
    cmp     #'/' ; Check for port or protocol
    bne     @url_not_well_formed ; At this step we found ':/' which the third char different than '/'' but no '://'

    ; A protocol is present


    jsr     detect_protocol

    cmp     #CURLPROTO_UNKNOWN
    beq     @exit_with_error

@no_protocol:
    jsr     parse_hostname

    cmp     #':'
    bne     @not_a_port
    jsr     detect_port

@not_a_port:
    ; Get Uri
    cmp    #'/'
    beq     @get_uri

@end_parse_url:
    lda     #CURLE_OK
    rts

@get_uri:

    ; Store position into url
    lda     #curl_struct::uri
    sta     save_position_into_uri

    inc     save_position_into_url ; We are after '/'

    ldy     save_position_into_url

@L1_get_uri:
    lda     (ptr_parameter),y
    beq     @end_get_uri
    ldy     save_position_into_uri
    sta     (curl_res),y
    inc     save_position_into_uri
    inc     save_position_into_url
    ldy     save_position_into_url
    cpy     #(CURL_MAX_LENGTH_URI + curl_struct::uri)
    bne     @L1_get_uri

    lda     #CURLE_TOO_LARGE
    rts

@end_get_uri:
    lda     #$00
    sta     (curl_res),y
    ; always ok
    beq     @end_parse_url

@url_not_well_formed:
    lda     #CURLE_URL_MALFORMAT
    rts

@exit_with_error:
    ldy     #curl_struct::protocol
    lda     #CURLPROTO_UNKNOWN
    sta     (curl_res),y
    lda     #CURLE_UNSUPPORTED_PROTOCOL
    rts

read_byte_url:

    rts

    ; cpy     #CURL_MAX_LENGTH_URL
    ; bne     @parse_full_url
    ; ; Error
    ; lda     #CURLE_TOO_LARGE
    ; rts


; Routine which parse hostname


parse_hostname:

    lda     #curl_struct::hostname
    sta     save_position_into_hostname

@L3:
    ldy     save_position_into_url
    lda     (ptr_parameter),y ; Get char from parameter
    beq     @end_parse_hostname
    cmp     #'/'
    beq     @end_parse_hostname
    cmp     #':'
    beq     @end_parse_hostname
    ldy     save_position_into_hostname
    inc     save_position_into_hostname
    sta     (curl_res),y
    inc     save_position_into_url
    bne     @L3

@end_parse_hostname:
    tax
    ldy     save_position_into_hostname
    lda     #$00
    sta     (curl_res),y
    txa     ; Restore A which could contains the char found '/' or ':' or 0

    rts



; ##############################################################
; #                   url option: detect protocol (http ...)   #
; ##############################################################

detect_protocol:

    ; Store ':' position
    ldx     #$00
    stx     search_id_protocol

@restart_protocol_search:
    ldy     #$00

@L1_search_protocol:
    lda     (ptr_parameter),y
    cmp     #':'
    beq     @validate
    cmp     protocol_str,x
    beq     @next_char
  ;  inx
; Search the end of the current protocol_str (current token)
@loop_list_protocol:
    lda     protocol_str,x
    beq     @continue
    inx
    bne     @loop_list_protocol
    ; Protocol not found, set error
    lda     #CURLPROTO_UNKNOWN

    rts


@continue:
    inc     search_id_protocol
    inx
    bne     @restart_protocol_search

@next_char:
    iny
    cpy     #CURL_MAX_LENGTH_URL
    beq     @no_slash_slash ; No protocol found
    inx
    bne     @L1_search_protocol

@validate:

    iny ; Skip ':'
    iny ; Skip '/'
    iny ; Skip '/'


    ; At this step protocol is recognized

    ; Move pointer after //
    sty     save_position_into_url



    ; Store right protocol
    ldx     search_id_protocol
    lda     mapping_protocol,x
    ldy     #curl_struct::protocol
    sta     (curl_res),y

    ; Now set default port for protocol
    lda     mapping_protocol_port_dest_low,x
    ldy     #curl_struct::dest_port
    sta     (curl_res),y

    lda     mapping_protocol_port_dest_high,x
    iny
    sta     (curl_res),y

    ; Store into url "//"
    lda     #'/'
    ldy     save_pos_curl_res
    sta     (curl_res),y
    iny
    sta     (curl_res),y
    iny
    sty     save_pos_curl_res
    rts

@no_slash_slash:
    rts

detect_port:
    ldx     #$00
    ; We de
    inc     save_position_into_url
    ldy     save_position_into_url

@L1_detect_port:
    lda     (ptr_parameter),y
    beq     @convert
    cmp     #'/'
    beq     @convert

    cmp     #$30    ; Compare avec '0' (code ASCII $30)
    bcc     not_num ; Si A < '0', la retenue (Carry) est effacée -> Pas un chiffre
    cmp     #$3A    ; Compare avec '9' + 1 (code ASCII $39 + 1 = $3A)
    bcs     not_num ; Si A >= $3A, la retenue (Carry) est définie -> Pas un chiffre

    inc     save_position_into_url
    sta     port_ascii,x
    inx
    cpx     #$06 ; Max 5 digits for port + null terminator
    beq     not_num ; Too long port number
    iny
    bne     @L1_detect_port

@convert:
    ; Skip '/'
   ; inc     save_position_into_url
    pha     ; push current char into url
    lda     #$00
    sta     port_ascii,x ; Null terminator

    lda     #<port_ascii
    ldx     #>port_ascii
    jsr     _atoi

    ; Store port

    ldy     #curl_struct::dest_port
    sta     (curl_res),y
    txa
    iny
    sta     (curl_res),y
    pla    ; restore char into url
    rts

@end_detect_port:
    lda     #CURLE_OK
    rts

not_num:
    lda     #CURLE_URL_MALFORMAT
    rts



port_ascii:
    .res 5 + 1
.endproc


