---

## curl_easy_setopt
***Description***

Set opt
***Input***

* Accumulator : Low struct curl ptr
* X Register : High struct curl ptr
* Y Register : CURLOPT_URL 
* RES : parameter 
***Modify***

* TR0Tmp* TR1Tmp* TR2saveY tmp* TR3tmp* RESBPtr!!! note "send CURLE_TOO_LARGE if the url parameter is bigger than lib curl can"

const char protocol_str[5] = "http";