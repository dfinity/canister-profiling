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
|Motoko|274_773|510_637|[22_328](Motoko_dao_transfer.svg)|[18_552](Motoko_submit_proposal.svg)|[19_569](Motoko_vote.svg)|[157_602](Motoko_upgrade.svg)|
|Rust|778_222|611_282|[101_374](Rust_dao_transfer.svg)|[125_148](Rust_submit_proposal.svg)|[137_434](Rust_vote.svg)|[1_816_495](Rust_upgrade.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|upgrade|
|--|--:|--:|--:|--:|--:|
|Motoko|221_922|481_158|[29_810](Motoko_nft_mint.svg)|[8_776](Motoko_nft_transfer.svg)|[89_459](Motoko_upgrade.svg)|
|Rust|790_671|239_293|[368_586](Rust_nft_mint.svg)|[89_013](Rust_nft_transfer.svg)|[2_001_978](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.2 (source vy3jgjpa-6ywclfhp-r10kgfpz-gkw93wh8)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
