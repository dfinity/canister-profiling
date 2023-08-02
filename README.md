# canister-profiling

This repository contains code and scripts for collecting performance data for different canisters running on the IC.

Community contributions are strongly encouraged.

## Performance report

Performance reports are generated in `gh-pages` branch. The reported Wasm binary size is after the instrumentation.

* [Sample dapps](http://dfinity.github.io/canister-profiling/dapps)
* [Collection libraries](http://dfinity.github.io/canister-profiling/collections)
* [Cryptographic libraries](http://dfinity.github.io/canister-profiling/crypto)
* [Publisher & Subscriber](http://dfinity.github.io/canister-profiling/pub-sub)
* [Heartbeat / Timer](http://dfinity.github.io/canister-profiling/heartbeat)
* [Motoko specific benchmarks](http://dfinity.github.io/canister-profiling/motoko)

## How to reproduce performance report

* Make sure that local replica is configured as system subnet. If not, run `cp networks.json ~/.config/dfx/`
* `dfx start --clean`
* Run `make -e MOC_VERSION=<MOC_VERSION>`
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

## Wasm Optimizer

A Wasm optimizer is applied to each Wasm binary before instrumentation (except the GC benchmarks). The optimizer can be found in [ic-wasm](https://github.com/dfinity/ic-wasm), which wraps [wasm-opt](https://github.com/WebAssembly/binaryen).

The following optimizations are applied:
```
ic-wasm -o <wasm> <wasm> shrink --optimize O3 --keep-name-section
```

Note that the name section is preserved in the optimization process. This is because the name section is used by the profiler to produce the flame graphs.

For users who wish to use the optimizer, the easiest way is to enable it via a field in `dfx.json`:

```
{
  "canisters": {
    "my_canister": {
      "optimize": "cycles"
    }
  }
}
```
This, as in most real world uses, removes the name section to minimize the binary size.
