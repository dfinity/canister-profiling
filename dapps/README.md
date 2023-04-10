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

| |binary_size|init|transfer_token|submit_proposal|vote_proposal|
|--|--:|--:|--:|--:|--:|
|Motoko|291_655|44_452|[19_923](Motoko_dao_transfer.svg)|[14_206](Motoko_submit_proposal.svg)|[16_811](Motoko_vote.svg)|
|Rust|944_361|542_161|[102_465](Rust_dao_transfer.svg)|[125_691](Rust_submit_proposal.svg)|[138_812](Rust_vote.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|
|--|--:|--:|--:|--:|
|Motoko|244_652|13_379|[24_678](Motoko_nft_mint.svg)|[5_358](Motoko_nft_transfer.svg)|
|Rust|998_014|147_146|[381_321](Rust_nft_mint.svg)|[95_515](Rust_nft_transfer.svg)|
