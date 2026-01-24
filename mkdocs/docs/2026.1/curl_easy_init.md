
***Description***

Create curl struct (calls XMALLOC from kernel)


***Modify***

* RESptr


***Returns***

* Accumulator : Low ptr curl struct
* Y Register : High ptr curl struct

***Example***

```asm
 jsr curl_easy_init
 ; And X contains ptr to curl handle
 rts
```

!!! note "Set default protocol to HTTP and default port to 80, hostname and uri to empty string, ip to 0.0.0.0"

