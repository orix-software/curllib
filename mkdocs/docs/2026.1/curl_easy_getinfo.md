
***Description***

get infos from curl ressource

***Input***

* Accumulator : Low ptr of curl ressource
* X Register : High ptr of curl ressource
* Y Register : Curl info to get ex : CURLINFO_PROTOCOL or CURLINFO_PRIMARY_PORT etc


***Modify***

* RES
* RESB2 bytes (for output ptr)
* TR0
* TR22 bytes

***Example***

```asm
 lda ptr_parameter_low ; ptr to parameter
 sta RESB ; ptr to parameter
 lda ptr_parameter_high ; ptr to parameter
 sta RESB + 1 ; ptr to parameter
 lda curl_handle_low ; ptr to curl handle
 ldx curl_handle_high ; ptr to curl handle
 ldy CURLINFO_PROTOCOL ; info to get
 jsr curl_easy_cleanup
 rts
```

!!! note "for CURLINFO_SCHEME, the parameter must be already allocated with enough space to store the string : 7 bytes"

!!! note "for CURLINFO_PRIMARY_IP, the parameter must be already allocated with enough space to store the string : eg : 16 bytes (xxx.xxx.xxx.xxx + null terminator)"

!!! note "returns CURLE_OK if ok, CURLE_UNKNOWN_OPTION if option unknown"

