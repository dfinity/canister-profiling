# Cryptographic libraries

Measure different cryptographic libraries written in both Motoko and Rust.

* SHA-2 benchmarks
  + `SHA-256/SHA-512`. Compute the hash of a 1M Wasm binary.
  + `account_id`. Compute the ledger account id from principal, based on SHA-224.
  + `neuron_id`. Compute the NNS neuron id from principal, based on SHA-256.
* Certified map. Merkle Tree for storing key-value pairs and generate witness according to the IC Interface Specification.
  + `generate 10k`. Insert 10k 7-character word as both key and value into the certified map.
  + `max mem`. For Motoko, it reports `rts_max_heap_size` after `generate` call; For Rust, it reports the Wasm's memory page * 32Kb.
  + `inc`. Increment a counter and insert the counter value into the map.
  + `witness`. Generate the root hash and a witness for the counter.
  + `upgrade`. Upgrade the canister with the same Wasm. In Motoko, we use stable variable. In Rust, we convert the tree to a vector before serialization.

## SHA-2

| |binary_size|SHA-256|SHA-512|account_id|neuron_id|
|--:|--:|--:|--:|--:|--:|
|Motoko|193_686|[267_743_355](Motoko_sha256.svg)|[247_834_501](Motoko_sha512.svg)|[33_636](Motoko_to_account.svg)|[24_532](Motoko_to_neuron.svg)|
|Rust|538_677|[82_788_763](Rust_sha256.svg)|[56_793_160](Rust_sha512.svg)|[47_956](Rust_to_account.svg)|[50_870](Rust_to_neuron.svg)|

## Certified map

| |binary_size|generate 10k|max mem|inc|witness|upgrade|
|--:|--:|--:|--:|--:|--:|--:|
|Motoko|243_641|4_666_119_661|3_430_044|[553_629](Motoko_inc.svg)|[407_936](Motoko_witness.svg)|[274_434_719](Motoko_upgrade.svg)|
|Rust|579_504|6_409_378_412|2_228_224|[1_020_591](Rust_inc.svg)|[304_778](Rust_witness.svg)|[6_025_902_205](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.18.0
> * Motoko compiler 0.11.0 (source lndfxrzc-zr7pf1k6-nr3nr3d7-jfla8nbn)
> * rustc 1.76.0 (07dca489a 2024-02-04)
> * ic-repl 0.7.0
> * ic-wasm 0.7.0
