---
hide:
  - toc
---


***Description***

void curl_easy_cleanup(CURL *handle);

***Input***

* handle The CURL handle to clean up. (This function is used to clean up a CURL handle that was previously initialized with curl_easy_init().)
!!! note "This function should be called when the handle is no longer needed to free up resources."

!!! note "This function is a no-op if the handle is NULL."

***Example***

```c

 main() {
 CURL *curl;
 curl = curl_easy_init();
 curl_easy_cleanup(curl);
 }
```

