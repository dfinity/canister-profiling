# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|161_290|145_741|[28_593](mo_subscribe.svg)|[11_963](mo_pub_register.svg)|[22_854](mo_publish.svg)|[6_446](mo_sub_update.svg)|
|Rust|535_946|573_818|[57_488](rs_subscribe.svg)|[37_798](rs_pub_register.svg)|[71_349](rs_publish.svg)|[42_449](rs_sub_update.svg)|

> ## Environment
> * dfx 0.18.0
> * Motoko compiler 0.11.0 (source lndfxrzc-zr7pf1k6-nr3nr3d7-jfla8nbn)
> * rustc 1.76.0 (07dca489a 2024-02-04)
> * ic-repl 0.7.0
> * ic-wasm 0.7.0
