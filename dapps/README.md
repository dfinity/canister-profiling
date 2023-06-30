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
|Motoko|242_539|40_990|[18_236](Motoko_dao_transfer.svg)|[12_676](Motoko_submit_proposal.svg)|[14_870](Motoko_vote.svg)|
|Rust|751_374|500_487|[93_345](Rust_dao_transfer.svg)|[114_984](Rust_submit_proposal.svg)|[124_724](Rust_vote.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|
|--|--:|--:|--:|--:|
|Motoko|200_814|12_164|[22_455](Motoko_nft_mint.svg)|[4_747](Motoko_nft_transfer.svg)|
|Rust|801_533|134_675|[348_766](Rust_nft_mint.svg)|[86_803](Rust_nft_transfer.svg)|
