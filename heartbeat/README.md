# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|118_909|[7_392](Motoko_heartbeat.svg)|
|Rust|23_699|[791](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|125_168|[15_208](Motoko_setTimer.svg)|[1_679](Motoko_cancelTimer.svg)|
|Rust|434_848|[43_540](Rust_setTimer.svg)|[7_683](Rust_cancelTimer.svg)|
