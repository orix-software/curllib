.include "telestrat.inc"
.include "curl.inc"

.include "../dependencies/orix-sdk/macros/SDK_memory.mac"

.export curl_easy_init

.proc curl_easy_init
    ;;@brief Create curl struct
    ;;@modifyMEM_RES ptr
    ;;@returnsA Low ptr curl struct
    ;;@returnsY High ptr curl struct

    malloc  .sizeof(curl_struct)
    cmp     #$FF
    bne     @continue
    cpy     #$FF
    bne     @continue

    ; OOM FIXME

    rts


@continue:
    sta     RES
    sty     RES+1

    ldy     #curl_struct::protocol
    sta     (RES),y

    ldy     #curl_struct::dest_port
    lda     #<80
    sta     (RES),y
    iny
    lda     #>80
    sta     (RES),y

    ; Set all values to 0
    ldy     #curl_struct::hostname
    lda     #$00
    sta     (RES),y

    ldy     #curl_struct::uri
    sta     (RES),y



    ; init to ip 0.0.0.0
    ldy     #curl_struct::ip_dest
    sta     (RES),y
    iny
    sta     (RES),y
    iny
    sta     (RES),y
    iny
    sta     (RES),y
    ; A = 0
    ldy     #curl_struct::curl_opt
    sta     (RES),y

    lda     RES
    ldy     RES+1

    rts
.endproc
