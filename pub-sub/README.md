# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|181_490|166_640|[16_645](mo_subscribe.svg)|[9_145](mo_pub_register.svg)|[12_539](mo_publish.svg)|[4_001](mo_sub_update.svg)|
|Rust|563_948|696_162|[63_407](rs_subscribe.svg)|[43_190](rs_pub_register.svg)|[89_378](rs_publish.svg)|[50_543](rs_sub_update.svg)|
