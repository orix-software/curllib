.include "curl.inc"
.include "telestrat.inc"
.include "_file.inc"

.include "../dependencies/orix-sdk/macros/SDK_print.mac"

.export curl_easy_setopt

.import curl_parse_url

.proc  curl_easy_setopt
    ;; curl_easy_setopt(curl, CURLOPT_URL, parameter);
    ;;@brief Set opt
    ;;@inputA Low struct curl ptr
    ;;@inputX High struct curl ptr
    ;;@inputY CURLOPT_URL
    ;;@inputMEM_RES  parameter
    ;;@modifyMEM_TR0 Tmp
    ;;@modifyMEM_TR1 Tmp
    ;;@modifyMEM_RESB Ptr
    ;;@note send CURLE_TOO_LARGE if the url parameter is bigger than lib curl can

    sta     RESB
    stx     RESB+1
    sty     TR0

    ldy     #curl_struct::curl_opt
    lda     (RESB),y
    eor     TR0
    sta     (RESB),y

    lda     TR0
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
    lda     (RESB),y
    ora     #CURLOPT_WRITEDATA
    sta     (RESB),y

@set_fp:
    ldy     #_FILE::f_fd
    lda     (RES),y        ; file->f_fd = fd;

    ldy     #curl_struct::curl_opt_ptr
    sta     (RESB),y

    lda     #CURLE_OK
    rts

@disable_write_data_option:
    lda     #curl_struct::curl_opt
    lda     (RESB),y
    eor     #CURLOPT_WRITEDATA
    sta     (RESB),y
    lda     #CURLE_OK
    rts

@verbose_option:
    print   verbose_option_str
    lda     #CURLE_OK
    rts

@dryrun_option:
    lda     #curl_struct::curl_opt
    lda     (RESB),y
    and     #CURLOPT_VERBOSE
    cmp     #CURLOPT_VERBOSE
    bne     @not_verbose_dryrun
    print   dryrun_option_str

@not_verbose_dryrun:
    lda     #CURLE_OK
    rts

@url_option:
    lda     #curl_struct::url
    sta     TR0

    ldy     #$00
@L1:
    lda     (RES),y
    beq     @out_copy_url

    ; FIXME 65C02 TYX instead
    sty     TR1

    ldy     TR0
    sta     (RESB),y
    inc     TR0
    ; FIXME 65C02 TXY instead
    ldy     TR1
    iny
    cpy     #CURL_MAX_LENGTH_URL
    bne     @L1
    ; Error
    lda     #CURLE_TOO_LARGE
    rts

@out_copy_url:
    ; Set eos
    ldy     TR0
    sta     (RESB),y
    lda     #CURLE_OK
    rts

.endproc
