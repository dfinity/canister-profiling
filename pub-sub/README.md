# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|161_935|146_225|[28_593](mo_subscribe.svg)|[11_963](mo_pub_register.svg)|[22_864](mo_publish.svg)|[6_430](mo_sub_update.svg)|
|Rust|519_866|570_028|[68_903](rs_subscribe.svg)|[42_634](rs_pub_register.svg)|[92_131](rs_publish.svg)|[51_818](rs_sub_update.svg)|

> ## Environment
> * dfx 0.16.1
> * Motoko compiler 0.10.4 (source js20w7g2-ysgfrqd0-1cmy11nb-3wdy9y1k)
> * rustc 1.75.0 (82e1608df 2023-12-21)
> * ic-repl 0.6.2
> * ic-wasm 0.7.0
