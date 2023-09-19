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
|Motoko|172_890|[247_480_401](Motoko_sha256.svg)|[228_033_044](Motoko_sha512.svg)|[30_017](Motoko_to_account.svg)|[20_760](Motoko_to_neuron.svg)|
|Rust|497_739|[82_511_907](Rust_sha256.svg)|[56_525_950](Rust_sha512.svg)|[42_406](Rust_to_account.svg)|[44_341](Rust_to_neuron.svg)|

## Certified map

| |binary_size|generate 10k|max mem|inc|witness|
|--:|--:|--:|--:|--:|--:|
|Motoko|176_829|4_390_018_085|3_429_924|[519_711](Motoko_inc.svg)|[327_767](Motoko_witness.svg)|
|Rust|440_119|6_202_162_996|1_081_344|[983_928](Rust_inc.svg)|[288_414](Rust_witness.svg)|
