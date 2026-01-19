---

## curl_easy_getinfo

***Description***

get infos from curl ressource

***Input***

* Accumulator : Low ptr of curl ressource
* X Register : High ptr of curl ressource
* Y Register : Curl info to get ex : CURLINFO_PROTOCOL or CURLINFO_PRIMARY_PORT etc


***Modify***

* RES
* RESB2 bytes
* TR0
* TR22 bytes

!!! note "for CURLINFO_SCHEME, the parameter must be already allocated with enough space to store the string : 7 bytes"

!!! note "for CURLINFO_PRIMARY_IP, the parameter must be already allocated with enough space to store the string : eg : 16 bytes (xxx.xxx.xxx.xxx + null terminator)"

