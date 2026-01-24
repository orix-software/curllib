---
hide:
  - toc
---



***Description***

convert errornum into str

***Input***

* errornum: The CURLcode error number
***Example***

```c

 main() {
 CURL *curl;
 char *url = "http://192.168.1.77:80/10K.htm";
 curl = curl_easy_init();
 res = curl_easy_setopt(curl, CURLOPT_URL, url);
 printf("%s\n", curl_easy_strerror(res));
 curl_easy_cleanup(curl);
 }
```

