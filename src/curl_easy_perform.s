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

.import inet_aton

.import socket_close
.import recv
.import send
.import socket
.import socket_close
.import connect

.import atoi32

.import ch395_set_sour_port_sn
.import ch395_set_des_port_sn
.import ch395_set_ip_addr_sn


.proc curl_easy_perform

    ;;@brief Performs request
    ;;@inputA Low ptr curl struct
    ;;@inputX High ptr curl struct
    ;;@modifyMEM_RES temp
    ;;@modifyMEM_RESB
    ;;@modifyMEM_HRS3
    ;;@modifyMEM_TR0
    ;;@modifyMEM_TR1
    ;;@modifyMEM_TR2
    ;;@modifyMEM_TR3
    ;;@modifyMEM_TR4
    ;;@modifyMEM_TR5
    ;;@modifyMEM_TR6
    ;;@modifyMEM_TR7
    ;;@returnsA CURLE_TOO_LARGE : Content length not found
    sta     RES
    stx     RES+1

    jsr     curl_parse_url
    cmp     #CURLE_OK ; Curl code error if different to 0, we return error
    beq     @parse_url_ok
    rts

@parse_url_ok:

    jsr     curl_save_res_into_hrs3

    lda     RES
    ldy     RES+1
    jsr     curl_print_object ; Modify HRS1, HRS2, RES

    ; Save ptr
    jsr     curl_load_res_from_hrs3

    lda     #curl_struct::hostname ; get hostname and check with_inet_aton if it's an ip
    clc
    adc     RES
    bcc     @S20
    inc     RES+1
@S20:
    ; A contains the ptr already

    ldx     RES+1

    jsr     inet_aton ; Use RES, RESB, TR0, TR4, TR5, TR6, TR7 (inetlib : 2024.2)

    cpx     #$00
    beq     @is_an_ip
    ; FIXME TO DO Resolv !
    ; Resolv IP here !!
    print str_resolver_not_handled_yet
    crlf
    rts

@is_an_ip:
    jsr     curl_load_res_from_hrs3

    ; Now copy ip to struct
    ldy     #curl_struct::ip_dest
    lda     TR4
    sta     (RES),y
    iny
    lda     TR5
    sta     (RES),y
    iny
    lda     TR6
    sta     (RES),y
    iny
    lda     TR7
    sta     (RES),y

    jsr     curl_save_res_into_hrs3

    lda     #$00
    ldx     #AF_INET
    ldy     #SOCK_STREAM

    jsr     socket ; Modify RES !


    cmp     #INVALID_SOCKET
    bne     @continue
    ; Invalid socket here

    rts

@continue:
    sta     curl_current_socket
    jsr     curl_load_res_from_hrs3
    ; store socket in struct
    ldy     #curl_struct::sockfd ; Save socket
    sta     (RES),y


    ldy     #curl_struct::dest_port
    lda     (RES),y
    sta     RESB+1
    iny
    lda     (RES),y
    sta     RESB


    ldx     RES+1
    ; Compute ip_dest_ptr
    lda     #curl_struct::ip_dest
    clc
    adc     RES
    bcc     @S22
    inx
@S22:
    tay
    ; at this step ip_dest is in Y and X
    jsr     curl_save_res_into_hrs3
    ; A contains the id of the socket
    lda     curl_current_socket
    jsr     connect
    cmp     #$00
    beq     @opened
    cmp     #EISCONN
    bne     @is_busy

    rts

@is_busy:
    ; manage_error
    rts

@opened:

    ; Same buffer used for read and write
    malloc 4096,curl_buffer
    ; Now populating sending buffer ...

    ldx     #$00
    ldy     #$00
    sty     curl_tmp1 ; Contains the length of the sending buffer

    ; Copy GET / into curl_buffer
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

    jsr     curl_load_res_from_hrs3 ; restore res

@L2:
    lda     (RES),y
    beq     @eos_uri
    ldy     curl_tmp1 ; Get the position of the buffer
    sta     (curl_buffer),y

    inc     curl_tmp1
    inc     curl_tmp2
    ldy     curl_tmp2
    jmp     @L2

@eos_uri:
    ldy     curl_tmp1
    ldx     #$00

    ; copy HTTP_1.0
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
    lda     (RES),y
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

    ; RES len buffer

    jsr     curl_save_res_into_hrs3
    lda     curl_buffer
    sta     RES
    lda     curl_buffer+1
    sta     RES+1

    lda     curl_current_socket

    ; Get length
    ldy     curl_tmp1
    ldx     #$00
    jsr     send ; Use RES, RESB, A, X,  Y

    cmp     #$00
    beq     @success_send
    print   error_send

    jmp     @close_socket

@success_send:
    lda     curl_current_socket
    ldy     curl_buffer
    ldx     curl_buffer+1

    jsr     recv ; Modify RES, RESB
    cmp     #ETIMEDOUT
    bne     @store
    print   str_timeout
    rts

@store:
    sty     curl_tmp1 ; Store length low
    stx     curl_tmp2 ; Store length High


    print   str_number_bytes
    ; Displays length
    lda     curl_tmp1
    ldy     curl_tmp2
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
    cpy     curl_tmp1
    bne     @loop_content       ; Overflow, content-length not found in the first 256 bytes
    ; Y=0
    inc     curl_lib_ptr2+1
    lda     #$00
    sta     curl_tmp1
    dec     curl_tmp2           ; Dec size
    bne     @loop_content
    ; at this step Content length not found
    lda     #CURLE_TOO_LARGE
    rts


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
    ; Store the number (string) into uri ptr
    jsr     curl_store_content_length_value_string_into_uri
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

    lda     #$00
    jsr     curl_store_content_length_value_string_into_uri

    ; lda     curl_pos_length_file_str
    ; clc
    ; adc     #curl_struct::uri
    ; tay
    ; lda     #$00
    ; sta     (curl_lib_ptr1),y

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

    jsr     curl_load_res_from_hrs3

    ldy     #curl_struct::curl_opt
    lda     (RES),y
    and     #CURLOPT_WRITEDATA
    cmp     #CURLOPT_WRITEDATA
    bne     @output_screen

    ldy     #curl_struct::curl_opt_ptr
    lda     (RES),y
    sta     curl_fp
    iny
    lda     (RES),y
    sta     curl_fp+1

    fwrite (curl_lib_ptr2), (curl_tmp1), 1, curl_fp
    fclose(curl_fp)
    jmp     @close_socket

; Output to screen

@output_screen:
    lda     curl_tmp2
    beq     @display_end

    lda     curl_buffer
    sta     RESB
    lda     curl_buffer+1
    sta     RESB+1

    ldy     #$00

@displ3:
    lda     (RESB),y
    BRK_TELEMON XWR0
    iny
    bne     @displ3
    inc     RESB+1
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

;     lda TR0
;     ldx     #<test_int32
;     ldy     #>test_int32
;     jsr     atoi32
; @me2:
;     jmp     @me2

    lda TR0

    ldx     curl_current_socket
    jsr     socket_close

    rts

.proc curl_store_content_length_value_string_into_uri
    pha
    lda     curl_pos_length_file_str
    clc
    adc     #curl_struct::uri   ; Recycling uri to store length of the content (string)
    tay
    pla
    sta     (curl_lib_ptr1),y
    inc     curl_pos_length_file_str
    rts
.endproc



str_resolver_not_handled_yet:
    .asciiz "hostname detected : Resolver not managed yet"

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
    .asciiz "Content-Length: "

str_content_length_size:
    .byte    16

test_int32:
    .asciiz "6000000"
.endproc

.proc curl_save_res_into_hrs3
    lda     RES
    sta     HRS3
    lda     RES+1
    sta     HRS3+1
    rts
.endproc

.proc curl_load_res_from_hrs3
    lda     HRS3
    sta     RES
    lda     HRS3+1
    sta     RES+1
    rts
.endproc




;GET /6502/2022.4/packages.lst HTTP/1.0
;Host: pkg.orix.oric.org