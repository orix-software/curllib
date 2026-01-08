# C

***Description***

void curl_easy_cleanup(CURL *handle);



## CURL *curl_easy_init();



***Description***

CURLcode curl_easy_perform(CURL *easy_handle);



const char str_ok[3] = "OK";
const char str_GET[6] = "GET /";
const char str_Host[7] = "Host: ";
const char error_send[11] = "send_error";
const char str_timeout[6] = "tmout";
const char str_number_bytes[24] = "Number bytes received: ";
const char str_content_length[17] = "content-length: ";
***Description***

CURLcode curl_easy_setopt(CURL *handle, CURLoption option, void parameter);

***Input***


***Input***


***Input***


***Input***




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
write_data_option:
   ; store fp
   ldy     #curl_struct::curl_opt_ptr
   lda     RES
   sta     (RESB),y
   iny
   lda     RES+1
   sta     (RESB),y
   lda     #CURLE_OK
   rts
verbose_option:
   print   verbose_option_str
   lda     #CURLE_OK
   rts
dryrun_option:
   lda     #curl_struct::curl_opt
   lda     (RESB),y
   and     #CURLOPT_VERBOSE
   cmp     #CURLOPT_VERBOSE
   bne     @not_verbose_dryrun
   print   dryrun_option_str
not_verbose_dryrun:
   lda     #CURLE_OK
   rts
url_option:
   lda     #curl_struct::url
   sta     TR0
   ldy     #$00
L1:
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
out_copy_url:
   ; Set eos
   ldy     TR0
   sta     (RESB),y
   lda     #CURLE_OK
   rts
endproc


const char supported_protocol_str[5] = "http";
const char str_curl_object[15] = "Curl object : ";
const char str_hostname[13] = " Hostname : ";
const char str_port[9] = " Port : ";
const char str_ip_dest[7] = " Ip : ";
const char str_uri[8] = " Uri : ";
const char str_options[12] = " Options : ";
const char str_CURLOPT_HEADER[16] = "CURLOPT_HEADER ";
const char str_CURLOPT_WRITEDATA[19] = "CURLOPT_WRITEDATA ";


