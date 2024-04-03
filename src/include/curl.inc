

.define CURL_MAX_LENGTH_HOSTNAME       20
.define CURL_MAX_LENGTH_URI            40
.define CURL_MAX_LENGTH_PORT           5
.define CURL_MAX_LENGTH_PROTOCOL       8 ; Ex : https://
.define CURL_MAX_LENGTH_SEPARATOR_URL  1 ; Ex : ':' port port

.define CURL_MAX_LENGTH_URL CURL_MAX_LENGTH_HOSTNAME + CURL_MAX_LENGTH_URI + CURL_MAX_LENGTH_PORT + CURL_MAX_LENGTH_PROTOCOL + CURL_MAX_LENGTH_SEPARATOR_URL

.define CURL_PROTOCOL_HTTP 1

.enum
    CURLE_OK ; No error
    CURLE_UNSUPPORTED_PROTOCOL
    CURLE_RANGE_ERROR
    CURLE_UNKNOWN_OPTION
    CURLE_TOO_LARGE ;               /* 100 - a value/data met its maximum */
.endenum
; OPT !!

CURLOPT_WRITEDATA = 1
CURLOPT_URL       = 2
CURLOPT_PORT      = 3 ;   /* Port number to connect to, if other than default. */
CURLOPT_HEADER    = 4
CURLOPT_VERBOSE   = 8
CURLOPT_DRYRUN    = 16

.struct curl_struct
    hostname            .res CURL_MAX_LENGTH_HOSTNAME
    sockfd              .res 1
    dest_port           .res 2
    ip_dest             .res 4
    uri                 .res CURL_MAX_LENGTH_URI
    url                 .res CURL_MAX_LENGTH_URL
    curl_opt_ptr        .res 2
    curl_opt            .res 1
    protocol            .res 1
.endstruct

.if     .sizeof(curl_struct) > 255
  .error  "curl_struct size is greater than 255. It's impossible because code does not handle a struct greater than 255"
.endif

curl_lib_zp_start        := $E0
curl_lib_ptr1            := curl_lib_zp_start ; 2 bytes
curl_current_socket      := $E2
curl_src_port            := $E4 ; 2 bytes
curl_count_0A_header     := $E4 ; 1 byte
curl_count_0D_header     := $E5 ; 1 byte
curl_dest_port           := $E6
curl_pos_length_file_str := $E6 ; 1 byte
curl_ip_dest             := $E8
curl_buffer              := $EA ; 2 byte
; let curl_tmp1 near curl_tmp1 because it's used for a ptr
curl_tmp1                := $EC ; 1 byte
curl_tmp2                := $ED
curl_fp                  := $EE ; 2 bytes
curl_savey               := $F0 ; one byte
curl_lib_ptr2            := $F2 ; 2 bytes
curl_lib_ptr3            := $F4 ; 2 bytes


.data
verbose_option_str:
    .byte "Verbose option",$0D,$0A,0

dryrun_option_str:
    .byte "Dryrun option",$0D,$0A,0

curl_version_str:
    .asciiz "2024.2"
