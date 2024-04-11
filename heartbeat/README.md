# Heartbeat / Timer

Measure the cost of empty heartbeat and timer job.

* `setTimer` measures both the `setTimer(0)` method and the execution of empty job.
* It is not easy to reliably capture the above events in one flamegraph, as the implementation detail
of the replica can affect how we measure this. Typically, a correct flamegraph contains both `setTimer` and `canister_global_timer` function. If it's not there, we may need to adjust the script.


## Heartbeat

| |binary_size|heartbeat|
|--:|--:|--:|
|Motoko|137_183|[19_507](Motoko_heartbeat.svg)|
|Rust|23_657|[480](Rust_heartbeat.svg)|

## Timer

| |binary_size|setTimer|cancelTimer|
|--:|--:|--:|--:|
|Motoko|145_619|[51_778](Motoko_setTimer.svg)|[4_626](Motoko_cancelTimer.svg)|
|Rust|502_754|[63_379](Rust_setTimer.svg)|[11_676](Rust_cancelTimer.svg)|

> ## Environment
> * dfx 0.18.0
> * Motoko compiler 0.11.0 (source lndfxrzc-zr7pf1k6-nr3nr3d7-jfla8nbn)
> * rustc 1.76.0 (07dca489a 2024-02-04)
> * ic-repl 0.7.0
> * ic-wasm 0.7.0
