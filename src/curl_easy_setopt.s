; A & Y ptr
; HRS1 option ID
; RES ptr last arg

.include "curl.inc"
.include "telestrat.inc"

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
    ;;@modifyMEM_RESB Ptr

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
    ldy     #curl_struct::curl_opt_ptr
    lda     RES
    sta     (RESB),y
    iny
    lda     RES+1
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

    jsr     curl_parse_url
    lda     #CURLE_OK
    rts

.endproc
