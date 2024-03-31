.include "telestrat.inc"
.include "curl.inc"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"

;.struct curl_struct
;    dest_port           .res 2
    ;hostname            .res CURL_SIZE_MAX_HOSTNAME
    ;ip_dest             .res 4
    ;uri                 .res CURL_SIZE_MAX_URI
;.endstruct

;ldy     #curl_struct::hostname

.export curl_print_object

.proc   curl_print_object
    ; A & Y contains the ptr of the object
    sta     HRS2
    sty     HRS2+1
    sty     HRS1+1

    crlf
    print str_curl_object
    crlf

    print str_hostname

    lda     #curl_struct::hostname
    clc
    adc     HRS2
    bcc     @skip
    inc     HRS1+1

@skip:
    sta     HRS1

    lda     HRS1
    ldy     HRS1+1
    BRK_TELEMON XWSTR0

    crlf

    print str_port

    lda     HRS2+1
    sta     HRS1+1

    ldy     #curl_struct::dest_port
    lda     (HRS2),y
    tax
    iny
    lda     (HRS2),y
    tay
    txa

    ldx     #$20 ;
    stx     DEFAFF
    ldx     #$00
    BRK_TELEMON XDECIM


    crlf

    print   str_ip_dest

    ldy     #curl_struct::ip_dest
    lda     (HRS2),y

    ldy     #$00
    ldx     #$03 ;
    stx     DEFAFF

    BRK_TELEMON XDECIM

    print   #'.'

    ldy     #curl_struct::ip_dest+1
    lda     (HRS2),y

    ldy     #$00
    ldx     #$03 ;
    stx     DEFAFF

    BRK_TELEMON XDECIM

    print   #'.'

    ldy     #curl_struct::ip_dest+2
    lda     (HRS2),y

    ldy     #$00
    ldx     #$03 ;
    stx     DEFAFF

    BRK_TELEMON XDECIM

    print   #'.'

    ldy     #curl_struct::ip_dest+3
    lda     (HRS2),y

    ldy     #$00
    ldx     #$03 ;
    stx     DEFAFF

    BRK_TELEMON XDECIM

    crlf
    print str_uri


    ldy     #curl_struct::uri

@loop:
    lda     (HRS2),y

    beq     @uri_eos
    BRK_TELEMON XWR0
    iny
    bne     @loop

@uri_eos:
    crlf
    print   str_options
    ldy     #curl_struct::curl_opt
    lda     (RES),y
    pha
    and     #CURLOPT_HEADER
    cmp     #CURLOPT_HEADER
    bne     @NO_CURLOPT_HEADER
    print   str_CURLOPT_HEADER

@NO_CURLOPT_HEADER:
    pla

    pha
    and     #CURLOPT_WRITEDATA
    cmp     #CURLOPT_WRITEDATA
    bne     @NO_CURLOPT_WRITEDATA
    print   str_CURLOPT_WRITEDATA

@NO_CURLOPT_WRITEDATA:
    pla
    crlf
    rts

str_curl_object:
    .asciiz "Curl object : "

str_hostname:
    .asciiz " Hostname : "

str_port:
    .asciiz " Port : "

str_ip_dest:
    .asciiz " Ip : "

str_uri:
    .asciiz " Uri : "

str_options:
    .asciiz " Options : "

str_CURLOPT_HEADER:
    .asciiz "CURLOPT_HEADER "

str_CURLOPT_WRITEDATA:
    .asciiz "CURLOPT_WRITEDATA "
.endproc
