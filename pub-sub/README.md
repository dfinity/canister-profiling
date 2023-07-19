# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|139_886|126_827|[14_632](mo_subscribe.svg)|[8_451](mo_pub_register.svg)|[10_530](mo_publish.svg)|[3_662](mo_sub_update.svg)|
|Rust|510_614|560_223|[52_071](rs_subscribe.svg)|[34_588](rs_pub_register.svg)|[74_157](rs_publish.svg)|[41_500](rs_sub_update.svg)|
