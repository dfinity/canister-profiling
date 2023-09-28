# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|123_509|[7_399](Motoko_heartbeat.svg)|
|Rust|23_826|[785](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|129_780|[15_227](Motoko_setTimer.svg)|[1_684](Motoko_cancelTimer.svg)|
|Rust|441_467|[43_465](Rust_setTimer.svg)|[7_594](Rust_cancelTimer.svg)|
