# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|181_458|166_608|[16_644](mo_subscribe.svg)|[9_145](mo_pub_register.svg)|[12_538](mo_publish.svg)|[4_001](mo_sub_update.svg)|
|Rust|561_379|696_578|[62_781](rs_subscribe.svg)|[42_457](rs_pub_register.svg)|[87_978](rs_publish.svg)|[49_653](rs_sub_update.svg)|
