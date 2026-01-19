---

## curl_easy_setopt

***Description***

Set opt

***Input***

* Accumulator : Low struct curl ptr
* X Register : High struct curl ptr
* Y Register : CURLOPT_URL 
* RES : parameter (from stack)

***Modify***

* TR0Tmp
* TR1Tmp
* TR2saveY tmp
* TR3tmp
* TR4tmp
* TR6tmp
* TR7tmp
* RESBPtr

!!! note "send CURLE_TOO_LARGE if the url parameter is bigger than lib curl can"

!!! note "send CURLE_TOO_LARGE if the uri parameter is bigger than lib curl can (CURL_MAX_LENGTH_URI into curl.h)"

