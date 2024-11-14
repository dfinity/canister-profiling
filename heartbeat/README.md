# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|142_246|[27_494](Motoko_heartbeat.svg)|
|Rust|26_684|[1_201](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|150_072|[56_158](Motoko_setTimer.svg)|[4_695](Motoko_cancelTimer.svg)|
|Rust|554_248|[64_790](Rust_setTimer.svg)|[12_216](Rust_cancelTimer.svg)|

> ## Environment
> * dfx 0.24.0
> * Motoko compiler 0.13.3 (source ff4il9yc-sfakbpl1-8z4dm2d6-ybdjncj7)
> * rustc 1.81.0 (eeb90cda1 2024-09-04)
> * ic-repl 0.7.6
> * ic-wasm 0.9.0
