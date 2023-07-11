# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|139_950|126_891|[14_632](mo_subscribe.svg)|[8_451](mo_pub_register.svg)|[10_530](mo_publish.svg)|[3_662](mo_sub_update.svg)|
|Rust|478_363|527_114|[57_647](rs_subscribe.svg)|[38_523](rs_pub_register.svg)|[81_062](rs_publish.svg)|[45_691](rs_sub_update.svg)|
