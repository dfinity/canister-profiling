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
|Motoko|173_412|[297_725_367](Motoko_sha256.svg)|[281_729_738](Motoko_sha512.svg)|[37_735](Motoko_to_account.svg)|[27_166](Motoko_to_neuron.svg)|
|Rust|478_873|[82_788_111](Rust_sha256.svg)|[56_793_155](Rust_sha512.svg)|[49_455](Rust_to_account.svg)|[52_124](Rust_to_neuron.svg)|

## Certified map

| |binary_size|generate 10k|max mem|inc|witness|upgrade|
|--:|--:|--:|--:|--:|--:|--:|
|Motoko|206_652|5_254_991_528|3_430_044|[623_666](Motoko_inc.svg)|[436_318](Motoko_witness.svg)|[274_614_372](Motoko_upgrade.svg)|
|Rust|503_545|6_309_529_790|2_228_224|[1_004_189](Rust_inc.svg)|[301_445](Rust_witness.svg)|[5_926_705_911](Rust_upgrade.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
