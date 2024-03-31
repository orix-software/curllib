# Assembly

## curl_easy_cleanup



## curl_easy_init

***Description***

Create curl struct


***Modify***

* RESptr

***Returns***

* Accumulator : Low ptr curl struct

* Y Register : High ptr curl struct



## curl_easy_perform



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
* RESBPtr


## curl_easy_strerror



## curl_parse_url



## curl_print_object



   jmp     curl_version
endproc
## curl_version



