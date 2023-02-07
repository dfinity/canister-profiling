# canister-profiling

This repository contains code and scripts for collecting performance data for different canisters running on the IC.

Community contributions are strongly encouraged.

## Performance report

Performance reports are generated in `gh-pages` branch. For some technical reasons, the flamegraph is from right to left.
The reported Wasm binary size is after the instrumentation.

* [Basic DAO](http://dfinity.github.io/canister-profiling/basic_dao)
* [Collection libraries](http://dfinity.github.io/canister-profiling/collections)
* [Publisher & Subscriber](http://dfinity.github.io/canister-profiling/pub-sub)
* [Heartbeat / Timer](http://dfinity.github.io/canister-profiling/heartbeat)
* [Motoko garbage collection](http://dfinity.github.io/canister-profiling/gc)

## How to reproduce performance report

* `dfx start --clean`
* In each directory, run `make`
* The results are stored in `_out/`

## How to create a new benchmark

Each benchmark usually contains multiple implementations written in different languages, e.g., Motoko and Rust.
The folder follows the following structure:

```
Benchmark_name/
  Makefile
  README.md // perf result will be appended to this markdown file
  perf.sh   // ic-repl script that generates perf result. If the candid interface is different, we can use two scripts in each implementation directory
  motoko/
    dfx.json
    src/
      benchmark1.mo
      benchmark2.mo
  rust/
    dfx.json
    benchmark1/
      Cargo.toml
      benchmark1.did
      src/
        lib.rs
    benchmark2/
      Cargo.toml
      benchmark2.did
      src/
        lib.rs
```
