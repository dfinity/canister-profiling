# Publisher & Subscriber

Measure the cost of inter-canister calls from the [Publisher & Subscriber](https://github.com/dfinity/examples/tree/master/motoko/pub-sub) example.


| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|171_699|156_846|[19_605](mo_subscribe.svg)|[9_145](mo_pub_register.svg)|[15_499](mo_publish.svg)|[4_001](mo_sub_update.svg)|
|Rust|564_006|696_272|[63_407](rs_subscribe.svg)|[43_190](rs_pub_register.svg)|[89_378](rs_publish.svg)|[50_543](rs_sub_update.svg)|
