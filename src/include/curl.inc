.define CURL_MAX_LENGTH_HOSTNAME       20
.define CURL_MAX_LENGTH_URI            40
.define CURL_MAX_LENGTH_PORT           5
.define CURL_MAX_LENGTH_PROTOCOL       7 ; Ex : https://
.define CURL_MAX_LENGTH_SEPARATOR_URL  1 ; Ex : ':' port port

.define CURL_MAX_LENGTH_URL CURL_MAX_LENGTH_HOSTNAME + CURL_MAX_LENGTH_URI + CURL_MAX_LENGTH_PORT + CURL_MAX_LENGTH_PROTOCOL + CURL_MAX_LENGTH_SEPARATOR_URL

.enum
    CURLE_OK ; No error
    CURLE_UNSUPPORTED_PROTOCOL
    CURLE_COULDNT_CONNECT
    CURLE_RANGE_ERROR
    CURLE_UNKNOWN_OPTION
    CURLE_URL_MALFORMAT
    CURLE_TOO_LARGE ;               /* 100 - a value/data met its maximum */
.endenum
; OPT !!
.enum
    CURLPROTO_HTTP ; Moved to have quicker search 0
    CURLPROTO_DICT ; 1
    CURLPROTO_FILE ; 2
    CURLPROTO_FTP  ; 3
    CURLPROTO_FTPS ; 4
    CURLPROTO_GOPHER    ; 5
    CURLPROTO_HTTPS  ; 6
    CURLPROTO_IMAP
    CURLPROTO_IMAPS
    CURLPROTO_LDAP
    CURLPROTO_LDAPS
    CURLPROTO_POP3
    CURLPROTO_POP3S
    CURLPROTO_RTMP
    CURLPROTO_RTMPE
    CURLPROTO_RTMPS
    CURLPROTO_RTMPT
    CURLPROTO_RTMPTE
    CURLPROTO_RTMPTS
    CURLPROTO_RTSP
    CURLPROTO_SCP
    CURLPROTO_SFTP
    CURLPROTO_SMB
    CURLPROTO_SMBS
    CURLPROTO_SMTP
    CURLPROTO_SMTPS
    CURLPROTO_TELNET
    CURLPROTO_TFTP
    CURLPROTO_UNKNOWN
.endenum


.enum
    CURLINFO_PROTOCOL        ; WARN ! will be deprecated ! Protocole utilisé pour la dernière transaction.
    CURLINFO_SCHEME
    CURLINFO_EFFECTIVE_URL   ; URL effective utilisée dans la dernière transaction.
    CURLINFO_RESPONSE_CODE   ; Code de réponse HTTP de la dernière transaction.
    CURLINFO_TOTAL_TIME      ; Temps total de la dernière transaction, en secondes.
    CURLINFO_NAMELOOKUP_TIME ; Temps passé à résoudre le nom de domaine, en secondes.
    CURLINFO_CONNECT_TIME    ; Temps passé à établir la connexion, en secondes.
    CURLINFO_PRETRANSFER_TIME   ;Temps passé avant le début du transfert de données, en secondes.
    CURLINFO_STARTTRANSFER_TIME ;Temps passé avant le début du transfert de données, en secondes.
    CURLINFO_SIZE_UPLOAD ;Taille totale des données téléchargées.
    CURLINFO_SIZE_DOWNLOAD ;Taille totale des données téléchargées.
    CURLINFO_SPEED_DOWNLOAD ;Vitesse moyenne de téléchargement, en octets par seconde.
    CURLINFO_SPEED_UPLOAD ;Vitesse moyenne de téléchargement, en octets par seconde.
    CURLINFO_HEADER_SIZE ;Taille de l'en-tête de réponse HTTP.
    CURLINFO_REQUEST_SIZE ;Taille de la requête HTTP envoyée.
    CURLINFO_SSL_VERIFYRESULT ;Résultat de la vérification SSL.
    CURLINFO_FILETIME ;Temps de modification du fichier distant, si disponible.
    CURLINFO_CONTENT_LENGTH_DOWNLOAD ;Taille du contenu téléchargé, si connue.
    CURLINFO_CONTENT_LENGTH_UPLOAD ;Taille du contenu téléchargé, si connue.
    CURLINFO_CONTENT_TYPE ;Type de contenu de la réponse HTTP.
    CURLINFO_REDIRECT_COUNT ;Nombre de redirections suivies.
    CURLINFO_REDIRECT_URL ;URL vers laquelle la dernière redirection a été faite.
    CURLINFO_PRIMARY_IP ;Adresse IP du serveur principal.
    CURLINFO_PRIMARY_PORT ;Port du serveur principal.
    CURLINFO_LOCAL_IP ;Adresse IP locale utilisée pour la connexion.
    CURLINFO_LOCAL_PORT ;Port local utilisé pour la connexion.
    CURLINFO_HTTP_CONNECTCODE ;Code de réponse HTTP de la requête CONNECT utilisée pour les tunnels proxy.
    CURLINFO_HTTPAUTH_AVAIL ;Méthodes d'authentification HTTP disponibles.
    CURLINFO_PROXYAUTH_AVAIL ;Méthodes d'authentification proxy disponibles.
    CURLINFO_OS_ERRNO ;Numéro d'erreur du système d'exploitation.
    CURLINFO_NUM_CONNECTS ;Nombre de connexions établies.
    CURLINFO_SSL_ENGINES ;Moteurs SSL disponibles.
    CURLINFO_COOKIELIST ;Liste des cookies.
    CURLINFO_LASTSOCKET ;Dernier socket utilisé.
    CURLINFO_FTP_ENTRY_PATH ;Chemin d'accès au répertoire FTP.
    CURLINFO_REDIRECT_TIME ;Temps total passé en redirections, en secondes.
    CURLINFO_APPCONNECT_TIME ;Temps passé à établir la connexion SSL/SSH, en secondes.
    CURLINFO_CERTINFO ;Informations sur le certificat SSL.
    CURLINFO_CONDITION_UNMET ;Indique si une condition n'a pas été remplie.
    CURLINFO_RTSP_SESSION_ID ;ID de session RTSP.
    CURLINFO_RTSP_CLIENT_CSEQ ;Numéro de séquence client RTSP.
    CURLINFO_RTSP_SERVER_CSEQ ;Numéro de séquence serveur RTSP.
    CURLINFO_RTSP_CSEQ_RECV ;Numéro de séquence reçu RTSP.
    CURLINFO_CONTENT_LENGTH_DOWNLOAD_T ;Taille du contenu téléchargé, en type curl_off_t.
    CURLINFO_CONTENT_LENGTH_UPLOAD_T ;Taille du contenu téléchargé, en type curl_off_t.
    CURLINFO_SIZE_UPLOAD_T ;Taille totale des données téléchargées, en type curl_off_t.
    CURLINFO_SIZE_DOWNLOAD_T ;Taille totale des données téléchargées, en type curl_off_t.
    CURLINFO_SPEED_DOWNLOAD_T ;Vitesse moyenne de téléchargement, en type curl_off_t.
    CURLINFO_SPEED_UPLOAD_T ;Vitesse moyenne de téléchargement, en type curl_off_t.
    CURLINFO_HOST ; Warn is not in original curl.h (linux) but needed for oric lib
.endenum

CURLOPT_WRITEDATA = 1
CURLOPT_URL       = 2
CURLOPT_HEADER    = 4
CURLOPT_VERBOSE   = 8
CURLOPT_DRYRUN    = 16
CURLOPT_PORT      = 32 ;   /* Port number to connect to, if other than default. */

.struct curl_struct
    hostname              .res CURL_MAX_LENGTH_HOSTNAME ; eg www.oric.org
    sockfd                .res 1
    dest_port             .word ; Destination port
    ip_dest               .res 4 ; Ip destination
    uri                   .res CURL_MAX_LENGTH_URI
    curl_opt_ptr          .word
    curl_opt              .res 1
    protocol              .res 1
    number_bytes_received .word
    content_length_string .res 9 ; Contains string digit of content length
    content_length_int    .res 4 ; Contains 32 bits int of content length
    curl_dynlib_bank      .res 1
    curl_dynlib_set       .res 1
    curl_dynlib_bank_bkp  .res 1
    curl_dynlib_set_bkp   .res 1
.endstruct

.if     .sizeof(curl_struct) > 255
  .error  "curl_struct size is greater than 255. It's impossible because code does not handle a struct greater than 255"
.endif

curl_lib_zp_start        := $E0
curl_lib_ptr1            := curl_lib_zp_start ; 2 bytes
curl_current_socket      := $E2
curl_count_0A_header     := $E3 ; 1 byte
curl_count_0D_header     := $E4 ; 1 byte
curl_pos_length_file_str := $E5 ; 1 byte
curl_number_of_bytes_received := $E6 ; 2 byte
curl_buffer              := $EA ; 2 byte
; let curl_tmp1 near curl_tmp1 because it's used for a ptr
curl_tmp1                := $EC ; 1 byte
curl_tmp2                := $ED
curl_fp                  := $EE ; 2 bytes
curl_savey               := $F0 ; one byte
curl_lib_ptr2            := $F2 ; 2 bytes


.data
curl_ptr_string_low:
    .byte <protocol_str_http
    .byte <protocol_str_dict
    .byte <protocol_str_file
    .byte <protocol_str_ftp
    .byte <protocol_str_ftps
    .byte <protocol_str_gopher
    .byte <protocol_str_https
    .byte <protocol_str_imap
    .byte <protocol_str_imaps
    .byte <protocol_str_ldap
    .byte <protocol_str_ldaps
    .byte <protocol_str_pop3
    .byte <protocol_str_pop3s
    .byte <protocol_str_rtmp
    .byte <protocol_str_rtmpe
    .byte <protocol_str_rtmps
    .byte <protocol_str_rmpt
    .byte <protocol_str_rmpte
    .byte <protocol_str_rmpts
    .byte <protocol_str_rtsp
    .byte <protocol_str_scp
    .byte <protocol_str_sftp
    .byte <protocol_str_smb
    .byte <protocol_str_smbs
    .byte <protocol_str_smtp
    .byte <protocol_str_smtps
    .byte <protocol_str_telnet
    .byte <protocol_str_tftp
    .byte <protocol_str_unknown

curl_ptr_string_high:
    .byte >protocol_str_http
    .byte >protocol_str_dict
    .byte >protocol_str_file
    .byte >protocol_str_ftp
    .byte >protocol_str_ftps
    .byte >protocol_str_gopher
    .byte >protocol_str_https
    .byte >protocol_str_imap
    .byte >protocol_str_imaps
    .byte >protocol_str_ldap
    .byte >protocol_str_ldaps
    .byte >protocol_str_pop3
    .byte >protocol_str_pop3s
    .byte >protocol_str_rtmp
    .byte >protocol_str_rtmpe
    .byte >protocol_str_rtmps
    .byte >protocol_str_rmpt
    .byte >protocol_str_rmpte
    .byte >protocol_str_rmpts
    .byte >protocol_str_rtsp
    .byte >protocol_str_scp
    .byte >protocol_str_sftp
    .byte >protocol_str_smb
    .byte >protocol_str_smbs
    .byte >protocol_str_smtp
    .byte >protocol_str_smtps
    .byte >protocol_str_telnet
    .byte >protocol_str_tftp
    .byte >protocol_str_unknown

protocol_str:
protocol_str_http:
    .byte  "http",0

protocol_str_dict:
    .asciiz "dict" ; 1

protocol_str_file:
    .asciiz "file" ; 2

protocol_str_ftp:
    .asciiz "ftp" ; 3

protocol_str_ftps:
    .asciiz "ftps" ; 4

protocol_str_gopher:
    .asciiz "gopher" ; 5

protocol_str_https:
    .asciiz "https" ; 6

protocol_str_imap:
    .asciiz "imap"

protocol_str_imaps:
    .asciiz "imaps"

protocol_str_ldap:
    .asciiz "ldap"

protocol_str_ldaps:
    .asciiz "ldaps"

protocol_str_pop3:
    .asciiz "pop3"

protocol_str_pop3s:
    .asciiz "pop3s"

protocol_str_rtmp:
    .asciiz "rtmp"

protocol_str_rtmpe:
    .asciiz "rtmpe"

protocol_str_rtmps:
    .asciiz "rtmps"

protocol_str_rmpt:
    .asciiz "rmpt"

protocol_str_rmpte:
    .asciiz "rmpte"

protocol_str_rmpts:
    .asciiz "rmpts"

protocol_str_rtsp:
    .asciiz "rtsp"

protocol_str_scp:
    .asciiz "scp"

protocol_str_sftp:
    .asciiz "sftp"

protocol_str_smb:
    .asciiz "smb"

protocol_str_smbs:
    .asciiz "smbs"

protocol_str_smtp:
    .asciiz "smtp"

protocol_str_smtps:
    .asciiz "smtps"

protocol_str_telnet:
    .asciiz "telnet"

protocol_str_tftp:
    .asciiz "tftp"

protocol_str_unknown:
    .asciiz "unknown"

end_protocol_str:

.if     end_protocol_str - protocol_str > 255
  .error  "Error protocol_str is greater than 255, curl_search_protocol will not work"
.endif


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


;verbose_option_str:
    ;.byte "Verbose option",$0D,$0A,0

;dryrun_option_str:
;    .byte "Dryrun option",$0D,$0A,0


