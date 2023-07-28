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
|Motoko|170_112|[264_156_344](Motoko_sha256.svg)|[235_099_564](Motoko_sha512.svg)|[35_144](Motoko_to_account.svg)|[23_250](Motoko_to_neuron.svg)|
|Rust|490_873|[82_512_107](Rust_sha256.svg)|[56_526_045](Rust_sha512.svg)|[42_397](Rust_to_account.svg)|[41_597](Rust_to_neuron.svg)|

## Certified map

| |binary_size|generate 10k|max mem|inc|witness|
|--:|--:|--:|--:|--:|--:|
|Motoko|162_416|18_579_897_273|3_429_924|[2_209_304](Motoko_inc.svg)|[327_765](Motoko_witness.svg)|
|Rust|433_845|6_206_795_630|1_081_344|[984_814](Rust_inc.svg)|[288_834](Rust_witness.svg)|
