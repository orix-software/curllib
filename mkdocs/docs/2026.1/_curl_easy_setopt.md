---
hide:
  - toc
---



***Description***

set opt for curl object (Ex : res = curl_easy_setopt(curl, CURLOPT_URL, "http://example)

***Input***

* handle: The curl handle
* option: The option to set
* parameter: The parameter for the option
***Example***

```c

 main() {
 CURL *curl;
 char *url = "http://192.168.1.77:80/10K.htm";
 curl = curl_easy_init();
 res = curl_easy_setopt(curl, CURLOPT_URL, url);
 curl_easy_cleanup(curl);
 }
```

