# C



## CURL *curl_easy_init();





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
   jsr     curl_parse_url
   lda     #CURLE_OK
   rts
endproc


const char str_curl_object[15] = "Curl object : ";
const char str_hostname[13] = " Hostname : ";
const char str_port[9] = " Port : ";
const char str_ip_dest[7] = " Ip : ";
const char str_uri[8] = " Uri : ";
const char str_options[12] = " Options : ";
const char str_CURLOPT_HEADER[16] = "CURLOPT_HEADER ";
const char str_CURLOPT_WRITEDATA[19] = "CURLOPT_WRITEDATA ";


