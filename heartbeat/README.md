# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|137_899|[19_511](Motoko_heartbeat.svg)|
|Rust|23_637|[1_112](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|146_290|[51_655](Motoko_setTimer.svg)|[4_610](Motoko_cancelTimer.svg)|
|Rust|487_585|[68_173](Rust_setTimer.svg)|[11_184](Rust_cancelTimer.svg)|

> ## Environment
> * dfx 0.16.1
> * Motoko compiler 0.10.4 (source js20w7g2-ysgfrqd0-1cmy11nb-3wdy9y1k)
> * rustc 1.75.0 (82e1608df 2023-12-21)
> * ic-repl 0.6.2
> * ic-wasm 0.7.0
