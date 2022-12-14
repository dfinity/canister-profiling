# Collection libraries

Measure different collection libraries written in both Motoko and Rust. 
The library names with `_rs` suffix are written in Rust; the rest are written in Motoko.

We use the same random number generator with fixed seed to ensure that all collections contain
the same elements in the collection, and the queries are exactly the same.

* generate 50k. Insert 50k Nat32 integers into the collection. For Motoko collections, it usually triggers the GC; the rest of the column are not likely to trigger GC.
* max mem. For Motoko, it reports `rts_max_live_size` after `generate` call; For Rust, it reports the Wasm's `memory.size` instruction.
* batch_get 50. Find 50 elements from the collection.
* batch_put 50. Insert 50 elements to the collection. Note that the Motoko version of `hashmap` uses Buffer as the underlying data structure. When the size reaches its capacity, it has to copy the whole collection to a new location. That is why the cost is significantly larger other collection data structures.
* batch_remove 50. Remove 50 elements from the collection. Note that the Motoko version of `rbtree` only performs logical removal of the elements. The removed elements still reside in memory, but not reachable from the map. You can also ignore this column in the priority queue table, as you cannot remove arbitrary elements from the priority queue.

The MoVM table measures performance of an experimental implementation of Motoko interpreter. External developers can ignore this table for now.
