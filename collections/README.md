# Collection libraries

Measure different collection libraries written in both Motoko and Rust. 
The library names with `_rs` suffix are written in Rust; the rest are written in Motoko.

We use the same random number generator with fixed seed to ensure that all collections contain
the same elements, and the queries are exactly the same. Below we explain the measurements of each column in the table:

* generate 50k. Insert 50k Nat32 integers into the collection. For Motoko collections, it usually triggers the GC; the rest of the column are not likely to trigger GC.
* max mem. For Motoko, it reports `rts_max_live_size` after `generate` call; For Rust, it reports the Wasm's memory page * 32Kb.
* batch_get 50. Find 50 elements from the collection.
* batch_put 50. Insert 50 elements to the collection.
* batch_remove 50. Remove 50 elements from the collection. Note that the Motoko version of `rbtree` only performs logical removal of the elements. The removed elements still reside in memory, but not reachable from the map. You can also ignore this column in the priority queue table, as you cannot remove arbitrary elements from the priority queue.

> **Note**
>
> * The Candid interface of the benchmark is minimal, therefore the serialization cost is negligible in this measurement.
> * Due to the instrumentation overhead, we cannot profile computations with more elements. Hopefully, when deterministic time slicing is ready, we can measure the performance on large memory footprint.
> * `hashmap` uses amortized data structure. When the initial capacity is reached, it has to copy the whole array, thus the cost of `batch_put 50` is much higher than other data structures.
> * `hashmap_rs` uses the `fxhash` crate, which is the same as the `HashMap` from std library, but with a deterministic hasher.
> * The MoVM table measures the performance of an experimental implementation of Motoko interpreter. External developers can ignore this table for now.
