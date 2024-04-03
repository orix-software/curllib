.include "telestrat.inc"
.include "include/curl.inc"
.include "socket.mac"
.include "socket.inc"
.include "ch395.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "../dependencies/orix-sdk/macros/SDK_memory.mac"
.include "../dependencies/orix-sdk/macros/SDK_file.mac"

curl_easy_perform_debug = 1

.export curl_easy_perform

.import curl_parse_url
.import curl_print_object

.import socket_close
.import recv
.import send
.import socket
.import socket_close

.import ch395_set_sour_port_sn
.import ch395_set_des_port_sn
.import ch395_set_ip_addr_sn

.proc curl_easy_perform
    ;;@brief Performs request
    ;;@inputA Low ptr curl struct
    ;;@inputX High ptr curl struct
    sta     RES
    stx     RES+1

    jsr     curl_parse_url
    cmp     #CURLE_OK ; Curl code error if different to 0, we return error
    beq     @parse_url_ok
    rts

@parse_url_ok:
    lda         RES
    ldy         RES+1
    jsr     curl_print_object
    rts
    ; sta     curl_lib_ptr1
    ; sty     curl_lib_ptr1+1
    ; sty     curl_src_port+1
    ; sty     curl_dest_port+1
    ; sty     curl_ip_dest+1

    lda     #$00
    ldx     #AF_INET
    ldy     #SOCK_STREAM
    jsr     socket

    sta     curl_current_socket
    cmp     #INVALID_SOCKET
    bne     @continue
    ; Invalid socket here

    rts

@continue:
    ; Let's compute
    lda     #curl_struct::ip_dest
    clc
    adc     curl_lib_ptr1
    bcc     @skip_inc_ip_dest
    inc     curl_ip_dest+1

@skip_inc_ip_dest:
    sta     curl_ip_dest

    ldy     #curl_struct::dest_port
    lda     (curl_lib_ptr1),y
    sta     curl_dest_port
    iny
    lda     (curl_lib_ptr1),y
    sta     curl_dest_port+1

    ; A contains the id of the socket
    lda     curl_current_socket
    ;socket_connect 202, (curl_dest_port), (curl_ip_dest)
    cmp     #$00
    beq     @opened
    cmp     #EISCONN
    bne     @is_busy

    rts
@is_busy:
    ; manage_error
    rts

@opened:
    print str_ok
    ; Same buffer used for read and write
    malloc 4096,curl_buffer
    ; Now populating sending buffer ...

    ldx     #$00
    ldy     #$00
    sty     curl_tmp1 ; Contains the length of the sending buffer

@L1:
    lda     str_GET,x
    beq     @end_copy_get
    sta     (curl_buffer),y
    inc     curl_tmp1
    inx
    iny
    bne     @L1

@end_copy_get:
    ldy     #curl_struct::uri
    sty     curl_tmp2

@L2:
    lda     (curl_lib_ptr1),y
    beq     @eos_uri
    ldy     curl_tmp1
    sta     (curl_buffer),y

    inc     curl_tmp1
    inc     curl_tmp2
    ldy     curl_tmp2
    jmp     @L2

@eos_uri:
    ldy     curl_tmp1
    ldx     #$00

@L3:
    lda     str_HTTP_1_0,x
    beq     @end_copy_str_HTTP_1_0
    sta     (curl_buffer),y
    inc     curl_tmp1
    iny
    inx
    bne     @L3

@end_copy_str_HTTP_1_0:
    ldy     curl_tmp1
    ldx     #$00

@L4:
    lda     str_Host,x
    beq     @end_copy_str_Host
    sta     (curl_buffer),y
    inc     curl_tmp1
    iny
    inx
    bne     @L4

@end_copy_str_Host:
    ldy     #curl_struct::hostname
    sty     curl_tmp2

@L5:
    lda     (curl_lib_ptr1),y
    beq     @eos_hostname
    ldy     curl_tmp1
    sta     (curl_buffer),y
    inc     curl_tmp1
    inc     curl_tmp2
    ldy     curl_tmp2
    jmp     @L5

@eos_hostname:
    ldy     curl_tmp1
    ; crlf twice
    lda     #$0D
    sta     (curl_buffer),y
    iny
    inc     curl_tmp1
    lda     #$0A
    sta     (curl_buffer),y
    iny
    inc     curl_tmp1

    lda     #$0D
    sta     (curl_buffer),y
    iny
    inc     curl_tmp1
    lda     #$0A
    sta     (curl_buffer),y
    inc     curl_tmp1

    crlf
    ldy     #$00
@displ:
    lda     (curl_buffer),y
    BRK_TELEMON XWR0
    iny
    cpy     curl_tmp1
    bne     @displ

    ; x socket
    ; ay buffer
    ; RES len buffer

    lda     curl_tmp1
    sta     RES
    lda     #$00
    sta     RES+1

    ldx     curl_current_socket
    lda     curl_buffer
    ldy     curl_buffer+1

    jsr     send

    cmp     #$00
    beq     @success_send


    print   error_send

    jmp     @close_socket

@success_send:
    ldx     curl_current_socket
    lda     curl_buffer
    ldy     curl_buffer+1

    jsr     recv
    cpx     #ETIMEDOUT
    bne     @store
    print   str_timeout
    rts

@store:
    sta     curl_tmp1 ; Store length
    stx     curl_tmp2

    print   str_number_bytes
    ; Displays length
    lda     curl_tmp1
    ldy     #$00
    ldx     #$03 ;
    stx     DEFAFF
    BRK_TELEMON XDECIM

    crlf

    lda     curl_buffer
    ldy     curl_buffer+1
    sta     curl_lib_ptr2
    sty     curl_lib_ptr2+1



; Use :
; curl_lib_ptr2
; curl_count_0A_header
; curl_count_0D_header
; curl_tmp1

;********************************************************
; Looking for content-length
;********************************************************


    ldy     #$00
    ldx     #$00

@loop_content:
    lda     (curl_lib_ptr2),y           ; Parse "content-length: string"
    cmp     str_content_length,x
    beq     @found_content_length
    ldx     #$00
    iny
    bne     @loop_content       ; Overflow, content-length not found in the first 256 bytes
    ; Y=0
    inc     curl_lib_ptr2+1
    dec     curl_tmp2           ; Dec size
    jmp     @loop_content

@found_content_length:
    iny
    inx
    cpx     str_content_length_size
    bne     @loop_content

    tya
    pha
    print    str_content_length ; Display "content length" string
    pla
    tay

;********************************************************
; Display content-length
;********************************************************
    lda     #$00
    sta     curl_pos_length_file_str

    ;ldy     #$00
@display_size_content_length:
    lda     (curl_lib_ptr2),y
    cmp     #$0D
    beq     @exit_content_length
    sty     curl_savey
    pha
    lda     curl_pos_length_file_str
    clc
    adc     #curl_struct::uri   ; Recycling uri to store length of the content (string)
    tay
    pla
    sta     (curl_lib_ptr1),y
    inc     curl_pos_length_file_str
    BRK_TELEMON XWR0         ; Display the char
    ldy     curl_savey
    iny
    bne     @display_size_content_length

@exit_content_length:
    ; Store 0 to the string
    ; remove Y (parse to the size of the file read)

    iny     ; $0A
    iny     ; Remove $0D
    sty     curl_savey
    lda     curl_tmp1
    sec
    sbc     curl_savey
    bcs     @do_not_remove_to_high
    dec     curl_tmp2

@do_not_remove_to_high:
    sta     curl_tmp1

    tya
    clc
    adc     curl_lib_ptr2
    bcc     @do_not_remove_to_high_buffer
    inc     curl_lib_ptr2+1

@do_not_remove_to_high_buffer:
    sta     curl_lib_ptr2

    lda     curl_pos_length_file_str
    clc
    adc     #curl_struct::uri
    tay
    lda     #$00
    sta     (curl_lib_ptr1),y

; At this step  curl_struct::uri in curl struct contains the length of the downloaded file

@out_str:
    crlf

;********************************************************
; Looking for the end of the header
;********************************************************
    lda     #$00
    sta     curl_count_0A_header
    sta     curl_count_0D_header

    ldy     #$00

@displ4:
    lda     (curl_lib_ptr2),y
    cmp     #$0D
    beq     @inc_0D
    cmp     #$0A
    beq     @inc_0A

    ; others chars : Reset counter
    lda     #$00
    sta     curl_count_0A_header
    sta     curl_count_0D_header
    iny
    bne     @displ4
    inc     curl_lib_ptr2+1
    dec     curl_tmp2
    jmp     @displ4

@inc_0A:
    inc     curl_count_0A_header
    iny
    bne     @no_inc_for_header_0A
    inc     curl_lib_ptr2+1
    dec     curl_tmp2

@no_inc_for_header_0A:
    jmp     @verif

@inc_0D:
    inc     curl_count_0D_header
    iny
    bne     @no_inc_for_header_0D
    inc     curl_lib_ptr2+1
    dec     curl_tmp2
@no_inc_for_header_0D:

@verif:
    lda     curl_count_0A_header
    cmp     #$02
    bne     @displ4
    lda     curl_count_0D_header
    cmp     #$02
    bne     @displ4


    sty     curl_savey
    lda     curl_tmp1
    sec
    sbc     curl_savey
    bcs     @do_not_remove_to_high2
    dec     curl_tmp2

@do_not_remove_to_high2:
    sta     curl_tmp1

    tya
    clc
    adc     curl_lib_ptr2
    bcc     @do_not_remove_to_high_buffer2
    inc     curl_lib_ptr2+1

@do_not_remove_to_high_buffer2:
    sta     curl_lib_ptr2

; Checking if option is set

    ldy     #curl_struct::curl_opt
    lda     (curl_lib_ptr1),y
    and     #CURLOPT_WRITEDATA
    cmp     #CURLOPT_WRITEDATA
    bne     @output_screen

    ldy     #curl_struct::curl_opt_ptr
    lda     (curl_lib_ptr1),y
    sta     curl_fp
    iny
    lda     (curl_lib_ptr1),y
    sta     curl_fp+1

    fwrite (curl_lib_ptr2), (curl_tmp1), 1, curl_fp
    fclose(curl_fp)
    jmp     @close_socket

; Output to screen

@output_screen:
    lda     curl_tmp2
    beq     @display_end

    ldy     #$00

@displ3:
    lda     (curl_lib_ptr2),y
    BRK_TELEMON XWR0
    iny
    bne     @displ3
    inc     curl_lib_ptr2+1
    dec     curl_tmp2
    bne     @displ3

    lda     curl_tmp1
    beq     @skip_end_buffer2

@display_end:
    ldy     #$00

@displ2:
    lda     (curl_lib_ptr2),y
    BRK_TELEMON XWR0
    iny
    cpy     curl_tmp1
    bne     @displ2

@skip_end_buffer2:

@close_socket:
    ldx     curl_current_socket
    jsr     socket_close

    rts

str_ok:
    .asciiz "OK"

str_HTTP_1_0:
    .byte " HTTP/1.0",$0D,$0A,0

str_GET:
    .asciiz "GET /"

str_Host:
    .asciiz "Host: "

error_send:
    .asciiz "send_error"

str_timeout:
    .asciiz "tmout"

str_number_bytes:
    .asciiz "Number bytes received: "

str_content_length:
    .asciiz "content-length: "

str_content_length_size:
    .byte    16
.endproc


;GET /6502/2022.4/packages.lst HTTP/1.0
;Host: pkg.orix.oric.org