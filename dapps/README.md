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
|Motoko|236_862|497_570|[16_252](Motoko_dao_transfer.svg)|[12_676](Motoko_submit_proposal.svg)|[14_116](Motoko_vote.svg)|[128_813](Motoko_upgrade.svg)|
|Rust|782_736|547_986|[86_609](Rust_dao_transfer.svg)|[105_996](Rust_submit_proposal.svg)|[117_902](Rust_vote.svg)|[1_624_429](Rust_upgrade.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|upgrade|
|--|--:|--:|--:|--:|--:|
|Motoko|195_127|472_267|[22_357](Motoko_nft_mint.svg)|[4_729](Motoko_nft_transfer.svg)|[71_602](Motoko_upgrade.svg)|
|Rust|804_410|217_220|[325_588](Rust_nft_mint.svg)|[78_144](Rust_nft_transfer.svg)|[1_797_069](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.15.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.5.1
> * ic-wasm 0.6.0
