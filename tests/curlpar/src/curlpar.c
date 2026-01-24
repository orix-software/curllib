#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "curl.h"

unsigned char check_parsing(char *url, unsigned int expected_port, unsigned char expected_protocol, char *expecting_scheme, char *expected_ip) {
    CURL *curl;
    CURLcode res, getinfo_res;
    char *scheme = "01234567";
    char *host = "255.255.255.255";
    unsigned char protocol;
    unsigned int dest_port = 0;

    // Afficher l'adresse du pointeur
    printf("----------------------\n");
    printf("Parsing and checking : %s\n", url);

    curl = curl_easy_init();

    // curl_easy_setopt(curl, CURLOPT_VERBOSE, 0);
    curl_easy_setopt(curl, CURLOPT_DRYRUN, 1);

    // Configuration de l'URL à récupérer
    res = curl_easy_setopt(curl, CURLOPT_URL, url);

    if (res == CURLE_TOO_LARGE) {
        printf("url is too long\n");
        return 1;
    }

    curl_easy_getinfo(curl, CURLINFO_SCHEME, &scheme);

    if (strcmp(expecting_scheme, scheme) != 0 )
    {
        printf("[ERROR] Expecting scfheme : %s, received : %s\n", expecting_scheme, scheme);
        return 1;
    }

    getinfo_res = curl_easy_getinfo(curl, CURLINFO_PRIMARY_PORT, &dest_port);


    if (expected_port != dest_port)
    {
        printf("[ERROR] Expected port: %d, port received : %d\n", expected_port, dest_port);
        return 1;
    }


    getinfo_res = curl_easy_getinfo(curl, CURLINFO_PROTOCOL, &protocol);
        switch(protocol) {
            case CURLPROTO_HTTP:
                printf("Protocol: HTTP\n");
                break;
            case CURLPROTO_HTTPS:
                printf("Protocol: HTTPS\n");
                break;
            case CURLPROTO_FTP:
                printf("Protocol: FTP\n");
                break;
            case CURLPROTO_FTPS:
                printf("Protocol: FTPS\n");
                break;
            case CURLPROTO_SCP:
                printf("Protocol: SCP\n");
                break;
            case CURLPROTO_SFTP:
                printf("Protocol: SFTP\n");
                break;
            case CURLPROTO_TELNET:
                printf("Protocol: TELNET\n");
                break;
            case CURLPROTO_LDAP:
                printf("Protocol: LDAP\n");
                break;
            case CURLPROTO_LDAPS:
                printf("Protocol: LDAPS\n");
                break;
            case CURLPROTO_FILE:
                printf("Protocol: FILE\n");
                break;
            case CURLPROTO_IMAP:
                printf("Protocol: IMAP\n");
                break;
            case CURLPROTO_IMAPS:
                printf("Protocol: IMAPS\n");
                break;
            case CURLPROTO_POP3:
                printf("Protocol: POP3\n");
                break;
            case CURLPROTO_POP3S:
                printf("Protocol: POP3S\n");
                break;
            case CURLPROTO_RTMP:
                printf("Protocol: RTMP\n");
                break;
            case CURLPROTO_RTMPT:
                printf("Protocol: RTMPT\n");
                break;
            case CURLPROTO_RTMPE:
                printf("Protocol: RTMPE\n");
                break;
            case CURLPROTO_RTMPTE:
                printf("Protocol: RTMPTE\n");
                break;
            case CURLPROTO_RTMPS:
                printf("Protocol: RTMPS\n");
                break;
            case CURLPROTO_RTMPTS:
                printf("Protocol: RTMPTS\n");
                break;
            case CURLPROTO_GOPHER:
                printf("Protocol: GOPHER\n");
                break;
            case CURLPROTO_DICT:
                printf("Protocol: DICT\n");
                break;
            case CURLPROTO_SMB:
                printf("Protocol: SMB\n");
                break;
            case CURLPROTO_SMBS:
                printf("Protocol: SMBS\n");
                break;
            default:
                printf("Protocol: Unknown\n");
                break;
        }


    if (expected_protocol != protocol)
    {
        printf("[ERROR] Protocol expected : %d received : %d\n", expected_protocol, protocol);
        return 1;
    }

    res = curl_easy_getinfo(curl, CURLINFO_HOST, &host);
    printf("HOST : %s\n", host);

    curl_easy_cleanup(curl);
    return 0;

}

int main() {
    unsigned char val;


    printf("Curl version : %s\n", curl_version());
    val = check_parsing("http://192.168.1.77:80/10K.htm", 80, CURLPROTO_HTTP, "http", "192.168.1.77");
    val = check_parsing("192.168.1.77:80/10K.htm", 80, CURLPROTO_HTTP, "http", "192.168.1.77");
    val = check_parsing("456.789.012.234/10K.htm", 80, CURLPROTO_HTTP, "http", "192.168.1.77");
    val = check_parsing("http://234.567.890.123/10K.htm", 80, CURLPROTO_HTTP, "http", "192.168.1.77");
    val = check_parsing("https://192.168.1.77/10K.htm", 443, CURLPROTO_HTTPS, "https", "192.168.1.77");
    val = check_parsing("gopherd://123.456.789.123/10K.htm", 80, CURLPROTO_UNKNOWN, "unknown", "192.168.1.77");
    val = check_parsing("gopher://192.168.1.77", 443, CURLPROTO_HTTP, "gopher", "192.168.1.77");

    return 0;
}