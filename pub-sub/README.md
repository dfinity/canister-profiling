# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|156_672|143_547|[15_760](mo_subscribe.svg)|[8_489](mo_pub_register.svg)|[11_737](mo_publish.svg)|[3_665](mo_sub_update.svg)|
|Rust|478_372|527_123|[57_647](rs_subscribe.svg)|[38_523](rs_pub_register.svg)|[81_062](rs_publish.svg)|[45_691](rs_sub_update.svg)|
