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

## SHA-2

| |binary_size|SHA-256|SHA-512|account_id|neuron_id|
|--:|--:|--:|--:|--:|--:|
|Motoko|174_597|[264_156_360](Motoko_sha256.svg)|[235_099_580](Motoko_sha512.svg)|[35_153](Motoko_to_account.svg)|[23_262](Motoko_to_neuron.svg)|
|Rust|498_272|[82_512_024](Rust_sha256.svg)|[56_525_977](Rust_sha512.svg)|[42_551](Rust_to_account.svg)|[44_574](Rust_to_neuron.svg)|

## Certified map

| |binary_size|generate 10k|max mem|inc|witness|
|--:|--:|--:|--:|--:|--:|
|Motoko|166_880|18_581_618_617|3_429_924|[2_209_513](Motoko_inc.svg)|[327_767](Motoko_witness.svg)|
|Rust|441_794|6_202_163_062|1_081_344|[983_904](Rust_inc.svg)|[288_469](Rust_witness.svg)|
