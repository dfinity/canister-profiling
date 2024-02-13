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
|Motoko|196_492|[273_037_090](Motoko_sha256.svg)|[259_835_230](Motoko_sha512.svg)|[34_373](Motoko_to_account.svg)|[24_897](Motoko_to_neuron.svg)|
|Rust|537_397|[82_787_911](Rust_sha256.svg)|[56_792_991](Rust_sha512.svg)|[47_914](Rust_to_account.svg)|[50_388](Rust_to_neuron.svg)|

## Certified map

| |binary_size|generate 10k|max mem|inc|witness|upgrade|
|--:|--:|--:|--:|--:|--:|--:|
|Motoko|245_183|4_763_349_709|3_430_044|[565_117](Motoko_inc.svg)|[402_073](Motoko_witness.svg)|[274_276_383](Motoko_upgrade.svg)|
|Rust|565_792|6_409_147_805|2_228_224|[1_019_959](Rust_inc.svg)|[303_897](Rust_witness.svg)|[6_019_483_730](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.16.1
> * Motoko compiler 0.10.4 (source js20w7g2-ysgfrqd0-1cmy11nb-3wdy9y1k)
> * rustc 1.75.0 (82e1608df 2023-12-21)
> * ic-repl 0.6.2
> * ic-wasm 0.7.0
