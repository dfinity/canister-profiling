# canister-profiling

This repository contains code and scripts for collecting performance data for different canisters running on the IC.

Community contributions are strongly encouraged.

## Performance report

Performance reports are generated in `gh-pages` branch. The reported Wasm binary size is after the instrumentation.

* [Sample dapps](http://dfinity.github.io/canister-profiling/dapps)
* [Collection libraries](http://dfinity.github.io/canister-profiling/collections)
* [Publisher & Subscriber](http://dfinity.github.io/canister-profiling/pub-sub)
* [Heartbeat / Timer](http://dfinity.github.io/canister-profiling/heartbeat)
* [Motoko specific benchmarks](http://dfinity.github.io/canister-profiling/motoko)

## How to reproduce performance report

* `dfx start --clean`
* Run `make`
* The results are stored in `_out/`

## How to create a new benchmark

Each benchmark usually contains multiple implementations written in different languages, e.g., Motoko and Rust.
The folder follows the following structure:

```
Benchmark_name/
  Makefile
  README.md // Perf result will be appended to this markdown file.
  perf.sh   // ic-repl script that generates perf result. If the candid interface is different, we can use multiple scripts.
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
