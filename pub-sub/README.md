# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|144_769|131_630|[14_651](mo_subscribe.svg)|[8_456](mo_pub_register.svg)|[10_539](mo_publish.svg)|[3_669](mo_sub_update.svg)|
|Rust|457_215|510_788|[51_624](rs_subscribe.svg)|[34_412](rs_pub_register.svg)|[74_396](rs_publish.svg)|[44_011](rs_sub_update.svg)|

> ## Environment
> * dfx 0.15.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.5.1
> * ic-wasm 0.6.0
