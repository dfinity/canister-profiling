# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|118_909|[7_392](Motoko_heartbeat.svg)|
|Rust|28_609|[830](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|125_231|[15_208](Motoko_setTimer.svg)|[1_679](Motoko_cancelTimer.svg)|
|Rust|447_442|[49_589](Rust_setTimer.svg)|[9_514](Rust_cancelTimer.svg)|
