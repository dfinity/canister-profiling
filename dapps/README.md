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
|Motoko|278_516|513_156|[23_340](Motoko_dao_transfer.svg)|[19_241](Motoko_submit_proposal.svg)|[20_489](Motoko_vote.svg)|[161_567](Motoko_upgrade.svg)|
|Rust|902_362|516_184|[92_673](Rust_dao_transfer.svg)|[118_753](Rust_submit_proposal.svg)|[113_669](Rust_vote.svg)|[1_499_571](Rust_upgrade.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|upgrade|
|--|--:|--:|--:|--:|--:|
|Motoko|224_643|482_025|[31_104](Motoko_nft_mint.svg)|[8_880](Motoko_nft_transfer.svg)|[91_835](Motoko_upgrade.svg)|
|Rust|931_779|205_310|[309_520](Rust_nft_mint.svg)|[73_609](Rust_nft_transfer.svg)|[1_635_207](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.24.0
> * Motoko compiler 0.13.0 (source dq4zmqc9-34xf70ip-6lrc3v7p-z1m6aq95)
> * rustc 1.81.0 (eeb90cda1 2024-09-04)
> * ic-repl 0.7.6
> * ic-wasm 0.9.0
