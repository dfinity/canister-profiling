# canister-profiling

This repository contains code and scripts for collecting performance data for different canisters running on the IC.

Community contributions are strongly encouraged.

## Performance report

Performance reports are generated in `gh-pages` branch.

* [Basic DAO](http://dfinity.github.io/canister-profiling/basic_dao)
* [Collection libraries](http://dfinity.github.io/canister-profiling/collections)
* [Publisher & Subscriber](http://dfinity.github.io/canister-profiling/pub-sub)
* [Heartbeat](http://dfinity.github.io/canister-profiling/heartbeat)
* [Motoko garbage collection](http://dfinity.github.io/canister-profiling/gc)

## How to reproduce performance report

* `dfx start --clean`
* In each directory, run `make`
* The results are stored in `_out/`
