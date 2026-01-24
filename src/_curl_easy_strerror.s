.export _curl_easy_strerror

.import curl_easy_strerror

.proc _curl_easy_strerror
    ;;@proto const char *curl_easy_strerror(CURLcode errornum);
    ;;@brief convert errornum into str
    ;;@param errornum: The CURLcode error number
    ;;@return const char *: Returns a pointer to a null-terminated string describing the error code passed in errornum.
    ;;@```code
    ;;@`  main() {
    ;;@`  CURL *curl;
    ;;@`  char *url = "http://192.168.1.77:80/10K.htm";
    ;;@`  curl = curl_easy_init();
    ;;@`  res = curl_easy_setopt(curl, CURLOPT_URL, url);
    ;;@`  printf("%s\n", curl_easy_strerror(res));
    ;;@`  curl_easy_cleanup(curl);
    ;;@` }
    ;;@```
    jmp     curl_easy_strerror

.endproc
