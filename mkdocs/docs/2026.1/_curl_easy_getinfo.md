---
hide:
  - toc
---



***Description***

Get info from curl

***Input***

* curl: The curl handle
* info: The info to get supported info : CURLINFO_PROTOCOL, CURLINFO_SCHEME, CURLINFO_PRIMARY_PORT, CURLINFO_HOST
* ...: The value to store the info in
!!! note "all parameters must be allocated before calling this function, because curl_easy_getinfo does not allocate memory for you. It means that if you want to get a string, you must allocate a buffer for it before calling this function (of the right size)."

!!! note "For CURLINFO_PROTOCOL ( unsigned char ), it can return one of the following values: CURLPROTO_HTTP, CURLPROTO_DICT, CURLPROTO_FILE, CURLPROTO_FTP, CURLPROTO_FTPS, CURLPROTO_GOPHER, CURLPROTO_HTTPS, CURLPROTO_IMAP, CURLPROTO_IMAPS, CURLPROTO_LDAP, CURLPROTO_LDAPS, CURLPROTO_POP3, CURLPROTO_POP3S, CURLPROTO_RTMP, CURLPROTO_RTMPE, CURLPROTO_RTMPS, CURLPROTO_RTMPT, CURLPROTO_RTMPTE, CURLPROTO_RTMPTS, CURLPROTO_RTSP, CURLPROTO_SCP, CURLPROTO_SFTP, CURLPROTO_SMB, CURLPROTO_SMBS, CURLPROTO_SMTP, CURLPROTO_SMTPS, CURLPROTO_TELNET, CURLPROTO_TFTP, CURLPROTO_UNKNOWN"

!!! note "For CURLINFO_SCHEME ( char * ), it can return one of the following strings: "HTTP", "DICT", "FILE", "FTP", "FTPS", "GOPHER", "HTTPS", "IMAP", "IMAPS", "LDAP", "LDAPS", "POP3", "POP3S", "RTMP", "RTMPE", "RTMPS", "RTMPT", "RTMPTE", "RTMPTS", "RTSP", "SCP", "SFTP", "SMB", "SMBS", "SMTP", "SMTPS", "TELNET", "TFTP""

!!! note "for CURLINFO_PRIMARY_PORT, it returns the integer value of the port number used for the connection. eg : unsigned int port = 80;"

!!! note "for CURLINFO_HOST, it returns the string value of the host name used for the connection. eg : char *host = "example.com";"

***Example***

```c

 main() {
 CURL *curl;
 char *scheme = "01234567";
 char *url = "http://192.168.1.77:80/10K.htm";
 curl = curl_easy_init();
 res = curl_easy_setopt(curl, CURLOPT_URL, url);
 curl_easy_getinfo(curl, CURLINFO_SCHEME, &scheme);
 curl_easy_cleanup(curl);
 }
```

