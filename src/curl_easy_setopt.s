.include "curl.inc"
.include "telestrat.inc"
.include "_file.inc"

.include "../dependencies/orix-sdk/macros/SDK_print.mac"

.export curl_easy_setopt

.import curl_parse_url
.import curl_print_object

.proc  curl_easy_setopt
    ;;@brief Set opt
    ;;@inputA Low struct curl ptr
    ;;@inputX High struct curl ptr
    ;;@inputY CURLOPT_URL
    ;;@inputMEM_RES parameter (from stack)
    ;;@modifyMEM_TR0 Tmp
    ;;@modifyMEM_TR1 Tmp
    ;;@modifyMEM_TR2 saveY tmp
    ;;@modifyMEM_TR3 tmp
    ;;@modifyMEM_TR4 tmp
    ;;@modifyMEM_TR6 tmp
    ;;@modifyMEM_TR7 tmp
    ;;@modifyMEM_RESB Ptr
    ;;@note send CURLE_TOO_LARGE if the url parameter is bigger than lib curl can
    ptr_parameter      := RES  ; ptr parameter
    curlopt            := TR0  ; option define
    curl_res           := RESB ; Curl resource
    save_pos_parameter := TR1
    save_pos_curl_res  := TR2
    search_id_protocol := TR3
    hostname_begin     := TR4
    save_pos_hostname  := TR5
    save_pos_uri       := TR6
    uri_begin          := TR7

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
    lda     #curl_struct::url ; 
    ; Recycle curlopt to save #curl_struct::url in struct
    sta     curlopt

    lda     #curl_struct::hostname
    sta     save_pos_hostname

    lda     #$01
    sta     hostname_begin

    ; Copy url into struct
    ldy     #$00

; General parsing for url parameter

@parse_full_url:
    lda     (ptr_parameter),y ; Get char from parameter
    beq     @out_copy_url  ; End of string
    ; Check if a port is provided
    cmp     #':' ; Check for port or protocol
    beq     @port_or_protocol_detected


@return_parse:
    ; FIXME 65C02 TYX instead
    sty     save_pos_parameter ; Save poistion in parameter

    ldy     curlopt ; curl_struct::url
    sta     (curl_res),y ; store char into
    inc     curlopt

    ; Does we read
    ldy     hostname_begin
    bne     @not_hostname
    ; Fill hostname
    cmp     #'/'
    bne     @fill_hostname

    ; Stop hostname fill because we reached  /
    ldy     #$01
    sty     hostname_begin
    bne     @not_hostname

@fill_hostname:
    ldy     save_pos_hostname
    sta     (curl_res),y
    inc     save_pos_hostname


@not_hostname:
    ; FIXME 65C02 TXY instead
    ldy     save_pos_parameter
    iny
    cpy     #CURL_MAX_LENGTH_URL
    bne     @parse_full_url
    ; Error
    lda     #CURLE_TOO_LARGE
    rts

@out_copy_url:
    ; Set eos
    ldy     curlopt
    sta     (curl_res),y


; Print debug
    ; lda     curl_res
    ; ldy     curl_res + 1
    ; jsr     curl_print_object

    lda     #CURLE_OK
    rts

@port_or_protocol_detected:
    cpy     #$06
    bcc     @detect_protocol     ; Y < 6 : detect protocol
    jmp     @return_parse


; ##############################################################
; #                   url option: detect protocol (http ...)   #
; ##############################################################

@detect_protocol:
    ; Store ':' position
    ldy     curlopt
    sta     (curl_res),y
    inc     curlopt

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
    jmp     @loop_list_protocol

@continue:
    inc     search_id_protocol
    inx
    bne     @restart_protocol_search

@next_char:
    iny
    inx
    bne     @L1_search_protocol

@validate:
    ; We are here because we reach a ':' and a token fully match (protocol)
    iny
    lda     (ptr_parameter),y
    cmp     #'/'
    bne     @protocol_not_supported
    iny
    lda     (ptr_parameter),y
    cmp     #'/'
    bne     @protocol_not_supported


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

    lda     #$00
    sta     hostname_begin



    inc     save_pos_parameter
    inc     save_pos_parameter
    inc     save_pos_parameter
    inc     save_pos_parameter

    ; Store into url "//"
    lda     #'/'
    ldy     save_pos_curl_res
    sta     (curl_res),y
    iny
    sta     (curl_res),y
    iny
    sty     save_pos_curl_res

    ldy     save_pos_parameter

    jmp     @parse_full_url


@protocol_not_supported:
    lda     #CURLE_UNSUPPORTED_PROTOCOL
    rts

.endproc

; protocol_str:
;     .asciiz "http"
;     .asciiz "dict"
;     .asciiz "file"
;     .asciiz "ftp"
;     .asciiz "ftps"
;     .asciiz "gopher"
;     .asciiz "https"
;     .asciiz "imap"
;     .asciiz "imaps" ;IMAP Secure (IMAP sur SSL/TLS)
;     .asciiz "ldap" ;Lightweight Directory Access Protocol (RFC 4511)
;     .asciiz "ldaps" ;LDAP Secure (LDAP sur SSL/TLS)
;     .asciiz "pop3" ;Post Office Protocol version 3 (RFC 1939)
;     .asciiz "pop3s" ;POP3 Secure (POP3 sur SSL/TLS)
;     .asciiz "rtmp" ;Real-Time Messaging Protocol
;     .asciiz "RTMPS" ;RTMP Secure (RTMP sur SSL/TLS)
;     .asciiz "RTMPE" ;RTMP Encrypted
;     .asciiz "RTMPT" ;RTMP Tunneled in HTTP
;     .asciiz "RTMPTE" ;RTMP Encrypted Tunneled in HTTP
;     .asciiz "RTSP" ;Real-Time Streaming Protocol (RFC 2326)
;     .asciiz "scp" ;Secure Copy Protocol (basé sur SSH)
;     .asciiz "sftp" ;SSH File Transfer Protocol (basé sur SSH)
;     .asciiz "smb" ;Server Message Block (également connu sous le nom de CIFS)
;     .asciiz "SMBS" ;SMB Secure (SMB sur SSL/TLS)
;     .asciiz "smtp" ;Simple Mail Transfer Protocol (RFC 5321)
;     .asciiz "smtps" ;SMTP Secure (SMTP sur SSL/TLS)
;     .asciiz "telnet" ;Telnet Protocol (RFC 854)
;     .asciiz "tftp" ;Trivial File Transfer Protocol (RFC 1350)


mapping_protocol:
    .byt CURLPROTO_HTTP
    .byt CURLPROTO_DICT
    .byt CURLPROTO_FILE
    .byt CURLPROTO_FTP
    .byt CURLPROTO_FTPS
    .byt CURLPROTO_GOPHER
    .byt CURLPROTO_HTTPS
    .byt CURLPROTO_IMAP
    .byt CURLPROTO_IMAPS
    .byt CURLPROTO_LDAP
    .byt CURLPROTO_LDAPS
    .byt CURLPROTO_POP3
    .byt CURLPROTO_POP3S
    .byt CURLPROTO_RTMP
    .byt CURLPROTO_RTMPE
    .byt CURLPROTO_RTMPS
    .byt CURLPROTO_RTMPT
    .byt CURLPROTO_RTMPTE
    .byt CURLPROTO_RTMPTS
    .byt CURLPROTO_RTSP
    .byt CURLPROTO_SCP
    .byt CURLPROTO_SFTP
    .byt CURLPROTO_SMB
    .byt CURLPROTO_SMBS
    .byt CURLPROTO_SMTP
    .byt CURLPROTO_SMTPS
    .byt CURLPROTO_TELNET
    .byt CURLPROTO_TFTP

mapping_protocol_port_dest_low:
    .byt <80
    .byt CURLPROTO_DICT
    .byt CURLPROTO_FILE
    .byt CURLPROTO_FTP
    .byt CURLPROTO_FTPS
    .byt CURLPROTO_GOPHER
    .byt <443
    .byt CURLPROTO_IMAP
    .byt CURLPROTO_IMAPS
    .byt CURLPROTO_LDAP
    .byt CURLPROTO_LDAPS
    .byt CURLPROTO_POP3
    .byt CURLPROTO_POP3S
    .byt CURLPROTO_RTMP
    .byt CURLPROTO_RTMPE
    .byt CURLPROTO_RTMPS
    .byt CURLPROTO_RTMPT
    .byt CURLPROTO_RTMPTE
    .byt CURLPROTO_RTMPTS
    .byt CURLPROTO_RTSP
    .byt CURLPROTO_SCP
    .byt CURLPROTO_SFTP
    .byt CURLPROTO_SMB
    .byt CURLPROTO_SMBS
    .byt CURLPROTO_SMTP
    .byt CURLPROTO_SMTPS
    .byt CURLPROTO_TELNET
    .byt CURLPROTO_TFTP

mapping_protocol_port_dest_high:
    .byt >80
    .byt CURLPROTO_DICT
    .byt CURLPROTO_FILE
    .byt CURLPROTO_FTP
    .byt CURLPROTO_FTPS
    .byt CURLPROTO_GOPHER
    .byt >443
    .byt CURLPROTO_IMAP
    .byt CURLPROTO_IMAPS
    .byt CURLPROTO_LDAP
    .byt CURLPROTO_LDAPS
    .byt CURLPROTO_POP3
    .byt CURLPROTO_POP3S
    .byt CURLPROTO_RTMP
    .byt CURLPROTO_RTMPE
    .byt CURLPROTO_RTMPS
    .byt CURLPROTO_RTMPT
    .byt CURLPROTO_RTMPTE
    .byt CURLPROTO_RTMPTS
    .byt CURLPROTO_RTSP
    .byt CURLPROTO_SCP
    .byt CURLPROTO_SFTP
    .byt CURLPROTO_SMB
    .byt CURLPROTO_SMBS
    .byt CURLPROTO_SMTP
    .byt CURLPROTO_SMTPS
    .byt CURLPROTO_TELNET
    .byt CURLPROTO_TFTP