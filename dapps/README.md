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
|Motoko|275_458|510_669|[22_262](Motoko_dao_transfer.svg)|[18_612](Motoko_submit_proposal.svg)|[19_635](Motoko_vote.svg)|[157_602](Motoko_upgrade.svg)|
|Rust|849_921|599_980|[99_156](Rust_dao_transfer.svg)|[123_702](Rust_submit_proposal.svg)|[136_655](Rust_vote.svg)|[1_799_892](Rust_upgrade.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|upgrade|
|--|--:|--:|--:|--:|--:|
|Motoko|222_607|481_158|[29_810](Motoko_nft_mint.svg)|[8_776](Motoko_nft_transfer.svg)|[89_459](Motoko_upgrade.svg)|
|Rust|869_104|236_542|[368_044](Rust_nft_mint.svg)|[91_941](Rust_nft_transfer.svg)|[1_999_272](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.16.1
> * Motoko compiler 0.10.4 (source js20w7g2-ysgfrqd0-1cmy11nb-3wdy9y1k)
> * rustc 1.75.0 (82e1608df 2023-12-21)
> * ic-repl 0.6.2
> * ic-wasm 0.7.0
