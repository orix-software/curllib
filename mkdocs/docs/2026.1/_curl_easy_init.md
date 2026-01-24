---
hide:
  - toc
---



***Description***

init curl session and returns the initialization of the curl object

!!! note "Set default protocol to HTTP and default port to 80, hostname and uri to empty string, ip to 0.0.0.0"

***Example***

```c

 main() {
 CURL *curl;
 curl = curl_easy_init();
 curl_easy_cleanup(curl);
 }
```

