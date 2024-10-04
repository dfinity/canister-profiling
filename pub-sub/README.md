# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|165_434|149_754|[32_863](mo_subscribe.svg)|[12_200](mo_pub_register.svg)|[27_064](mo_publish.svg)|[6_622](mo_sub_update.svg)|
|Rust|593_655|629_046|[59_348](rs_subscribe.svg)|[39_106](rs_pub_register.svg)|[74_039](rs_publish.svg)|[43_504](rs_sub_update.svg)|

> ## Environment
> * dfx 0.24.0
> * Motoko compiler 0.13.0 (source dq4zmqc9-34xf70ip-6lrc3v7p-z1m6aq95)
> * rustc 1.81.0 (eeb90cda1 2024-09-04)
> * ic-repl 0.7.6
> * ic-wasm 0.9.0
