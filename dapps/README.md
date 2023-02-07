# Sample Dapps

Measure the performance of some typical dapps:

* [Basic DAO](https://github.com/dfinity/examples/tree/master/motoko/basic_dao),
with `heartbeat` disabled to make profiling easier. We have a separate benchmark to measure heartbeat performance.
* [DIP721 NFT](https://github.com/dfinity/examples/tree/master/motoko/dip721-nft-container)

> **Note**
>
> * The cost difference is mainly due to the Candid serialization cost.
> * Motoko statically compiles/specializes the serialization code for each method, whereas in Rust, we use `serde` to dynamically deserialize data based on data on the wire.
> * We could improve the performance on the Rust side by using parser combinators. But it is a challenge to maintain the ergonomics provided by `serde`.
> * For real-world applications, we tend to send small data for each endpoint, which makes the Candid overhead in Rust tolerable.

