# Basic DAO

Measure the performance of a typical dapp from [Basic DAO](https://github.com/dfinity/examples/tree/master/motoko/basic_dao),
with `heartbeat` disabled to make profiling easier. We have a separate benchmark to measure heartbeat performance.

> **Note**
>
> * The cost difference is mainly due to the Candid serialization cost.
> * Motoko statically compiles/specializes the serialization code for each method, whereas in Rust, we use `serde` to dynamically deserialize data based on data on the wire.
> * Without modifying the Rust compiler, it can be challenging to match the Motoko compiler's performance, while at the same time maintaining the ergonomics provided by `serde`.
> * For real-world applications, we tend to send small data for each endpoint, which makes the Candid overhead in Rust tolerable.

