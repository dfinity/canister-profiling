# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|145_023|131_856|[28_786](mo_subscribe.svg)|[11_976](mo_pub_register.svg)|[23_098](mo_publish.svg)|[6_439](mo_sub_update.svg)|
|Rust|458_294|511_783|[69_854](rs_subscribe.svg)|[42_859](rs_pub_register.svg)|[92_892](rs_publish.svg)|[52_112](rs_sub_update.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
