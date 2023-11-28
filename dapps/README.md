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


## Basic DAO

| |binary_size|init|transfer_token|submit_proposal|vote_proposal|upgrade|
|--|--:|--:|--:|--:|--:|--:|
|Motoko|237_314|511_171|[22_841](Motoko_dao_transfer.svg)|[19_077](Motoko_submit_proposal.svg)|[20_221](Motoko_vote.svg)|[157_807](Motoko_upgrade.svg)|
|Rust|782_495|613_885|[101_922](Rust_dao_transfer.svg)|[126_043](Rust_submit_proposal.svg)|[137_819](Rust_vote.svg)|[1_825_005](Rust_upgrade.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|upgrade|
|--|--:|--:|--:|--:|--:|
|Motoko|195_621|481_132|[29_869](Motoko_nft_mint.svg)|[8_896](Motoko_nft_transfer.svg)|[89_994](Motoko_upgrade.svg)|
|Rust|804_148|240_775|[369_710](Rust_nft_mint.svg)|[91_916](Rust_nft_transfer.svg)|[2_014_251](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
