# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|161_257|145_541|[28_593](mo_subscribe.svg)|[11_963](mo_pub_register.svg)|[22_864](mo_publish.svg)|[6_430](mo_sub_update.svg)|
|Rust|456_613|507_753|[69_189](rs_subscribe.svg)|[42_865](rs_pub_register.svg)|[92_768](rs_publish.svg)|[52_116](rs_sub_update.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.2 (source vy3jgjpa-6ywclfhp-r10kgfpz-gkw93wh8)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
