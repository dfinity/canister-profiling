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
|Motoko|236_673|491_790|[16_290](Motoko_dao_transfer.svg)|[12_672](Motoko_submit_proposal.svg)|[14_136](Motoko_vote.svg)|[122_439](Motoko_upgrade.svg)|
|Rust|806_537|541_266|[86_052](Rust_dao_transfer.svg)|[107_287](Rust_submit_proposal.svg)|[117_056](Rust_vote.svg)|[1_686_510](Rust_upgrade.svg)|

## DIP721 NFT

| |binary_size|init|mint_token|transfer_token|upgrade|
|--|--:|--:|--:|--:|--:|
|Motoko|194_938|466_439|[22_357](Motoko_nft_mint.svg)|[4_729](Motoko_nft_transfer.svg)|[65_612](Motoko_upgrade.svg)|
|Rust|820_893|210_081|[324_368](Rust_nft_mint.svg)|[81_020](Rust_nft_transfer.svg)|[1_860_416](Rust_upgrade.svg)|
