# canister-profiling

This repository contains code and scripts for collecting performance data for different canisters running on the IC.

Community contributions are strongly encouraged.

## How to reproduce performance report

```
cd collections
dfx start --clean
dfx canister create --all
dfx build
ic-repl tests/perf.sh
```
