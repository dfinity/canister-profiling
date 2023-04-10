# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|156_851|[8_978](Motoko_heartbeat.svg)|
|Rust|35_608|[1_127](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|164_377|[19_476](Motoko_setTimer.svg)|[1_907](Motoko_cancelTimer.svg)|
|Rust|525_650|[55_806](Rust_setTimer.svg)|[10_541](Rust_cancelTimer.svg)|
