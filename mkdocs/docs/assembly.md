# Assembly

## curl_easy_cleanup

***Description***

free ressources

***Input***

* Accumulator : Low ptr
* X Register : High ptr


## curl_easy_init

***Description***

Create curl struct


***Modify***

* RESptr

***Returns***

* Accumulator : Low ptr curl struct

* Y Register : High ptr curl struct



## curl_easy_perform

***Description***

Performs request

***Input***

* Accumulator : Low ptr curl struct
* X Register : High ptr curl struct


## curl_easy_setopt

***Description***

Set opt

***Input***

* Accumulator : Low struct curl ptr
* X Register : High struct curl ptr
* Y Register : CURLOPT_URL 
* RES : parameter 

***Modify***

* TR0Tmp
* TR1Tmp
* RESBPtr
!!! note "send CURLE_TOO_LARGE if the url parameter is bigger than lib curl can"


## curl_easy_strerror



## curl_parse_url



## curl_search_protocol



## curl_print_object



   jmp     curl_version
endproc
## curl_version



