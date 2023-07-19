# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|118_909|[3_751](Motoko_heartbeat.svg)|
|Rust|26_624|[480](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|125_168|[15_208](Motoko_setTimer.svg)|[1_679](Motoko_cancelTimer.svg)|
|Rust|462_086|[43_483](Rust_setTimer.svg)|[7_663](Rust_cancelTimer.svg)|
