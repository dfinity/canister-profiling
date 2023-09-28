# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|144_583|131_443|[14_651](mo_subscribe.svg)|[8_456](mo_pub_register.svg)|[10_539](mo_publish.svg)|[3_669](mo_sub_update.svg)|
|Rust|477_393|527_108|[51_497](rs_subscribe.svg)|[34_484](rs_pub_register.svg)|[74_218](rs_publish.svg)|[44_132](rs_sub_update.svg)|
