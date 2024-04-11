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
|Motoko|273_938|510_825|[22_316](Motoko_dao_transfer.svg)|[18_597](Motoko_submit_proposal.svg)|[19_664](Motoko_vote.svg)|[157_964](Motoko_upgrade.svg)|
|Rust|847_522|506_485|[88_938](Rust_dao_transfer.svg)|[117_357](Rust_submit_proposal.svg)|[112_347](Rust_vote.svg)|[1_483_364](Rust_upgrade.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|upgrade|
|--|--:|--:|--:|--:|--:|
|Motoko|220_403|481_158|[30_204](Motoko_nft_mint.svg)|[8_764](Motoko_nft_transfer.svg)|[89_833](Motoko_upgrade.svg)|
|Rust|879_920|203_509|[303_060](Rust_nft_mint.svg)|[71_233](Rust_nft_transfer.svg)|[1_629_856](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.18.0
> * Motoko compiler 0.11.0 (source lndfxrzc-zr7pf1k6-nr3nr3d7-jfla8nbn)
> * rustc 1.76.0 (07dca489a 2024-02-04)
> * ic-repl 0.7.0
> * ic-wasm 0.7.0
