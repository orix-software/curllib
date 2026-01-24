
***Description***

free curl ressources

***Input***

* Accumulator : Low ptr of curl ressources
* X Register : High ptr of curl ressources

***Example***

```asm
 lda curl_handle_low ; ptr to curl handle
 ldx curl_handle_high ; ptr to curl handle
 jsr curl_easy_cleanup
 rts
```

