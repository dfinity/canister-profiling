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
|Motoko|199_257|[282_867_517](Motoko_sha256.svg)|[262_958_028](Motoko_sha512.svg)|[34_369](Motoko_to_account.svg)|[25_335](Motoko_to_neuron.svg)|
|Rust|596_836|[82_782_948](Rust_sha256.svg)|[56_788_520](Rust_sha512.svg)|[42_522](Rust_to_account.svg)|[41_228](Rust_to_neuron.svg)|

## Certified map

| |binary_size|generate 10k|max mem|inc|witness|upgrade|
|--:|--:|--:|--:|--:|--:|--:|
|Motoko|248_058|365_606_356|342_396|[397_640](Motoko_inc.svg)|[267_761](Motoko_witness.svg)|[22_396_932](Motoko_upgrade.svg)|
|Rust|640_537|489_666_578|1_310_720|[660_965](Rust_inc.svg)|[220_622](Rust_witness.svg)|[450_827_450](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.24.0
> * Motoko compiler 0.13.3 (source ff4il9yc-sfakbpl1-8z4dm2d6-ybdjncj7)
> * rustc 1.81.0 (eeb90cda1 2024-09-04)
> * ic-repl 0.7.6
> * ic-wasm 0.9.0
