
***Description***

Set opt

***Input***

* Accumulator : Low struct curl ptr
* X Register : High struct curl ptr
* Y Register : CURLOPT option to set (CURLOPT_URL only handled)
* RES : parameter 

***Modify***

* TR0Tmp
* TR2saveY tmp
* TR3tmp
* HRStmp
* RESBPtr

***Example***

```asm
 jsr curl_easy_setopt
 rts
```

!!! note "send CURLE_TOO_LARGE if the *url* parameter is bigger than lib curl can"

!!! note "send CURLE_TOO_LARGE if the ** parameter is bigger than lib curl can (CURL_MAX_LENGTH_URI into curl.h)"

!!! note "uses atoi from cc65 telestrat.lib instead of reimplementing it or calling it from orix kernel"

!!! note "Handles only *CURLOPT_URL* option"

