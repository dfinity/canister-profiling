# Collection libraries

Measure different collection libraries written in both Motoko and Rust. 
The library names with `_rs` suffix are written in Rust; the rest are written in Motoko.
The `_stable` and `_stable_rs` suffix represents that the library directly writes the state to stable memory using `Region` in Motoko and `ic-stable-stuctures` in Rust.

We use the same random number generator with fixed seed to ensure that all collections contain
the same elements, and the queries are exactly the same. Below we explain the measurements of each column in the table:

* generate 1m. Insert 1m Nat64 integers into the collection. For Motoko collections, it usually triggers the GC; the rest of the column are not likely to trigger GC.
* max mem. For Motoko, it reports `rts_max_heap_size` after `generate` call; For Rust, it reports the Wasm's memory page * 32Kb.
* batch_get 50. Find 50 elements from the collection.
* batch_put 50. Insert 50 elements to the collection.
* batch_remove 50. Remove 50 elements from the collection.
* upgrade. Upgrade the canister with the same Wasm module. For non-stable benchmarks, the map state is persisted by serializing and deserializing states into stable memory. For stable benchmarks, the upgrade only needs to initialize the metadata, as the state is already in the stable memory.

## **💎 Takeaways**

* The platform only charges for instruction count. Data structures which make use of caching and locality have no impact on the cost.
* We have a limit on the maximal cycles per round. This means asymptotic behavior doesn't matter much. We care more about the performance up to a fixed N. In the extreme cases, you may see an $O(10000 n\log n)$ algorithm hitting the limit, while an $O(n^2)$ algorithm runs just fine.
* Amortized algorithms/GC may need to be more eager to avoid hitting the cycle limit on a particular round.
* Rust costs more cycles to process complicated Candid data, but it is more efficient in performing core computations.

> **Note**
>
> * The Candid interface of the benchmark is minimal, therefore the serialization cost is negligible in this measurement.
> * Due to the instrumentation overhead and cycle limit, we cannot profile computations with very large collections.
> * The `upgrade` column uses Candid for serializing stable data. In Rust, you may get better cycle cost by using a different serialization format. Another slowdown in Rust is that `ic-stable-structures` tends to be slower than the region memory in Motoko.
> * Different library has different ways for persisting data during upgrades, there are mainly three categories:
>   + Use stable variable directly in Motoko: `zhenya_hashmap`, `btree`, `vector`
>   + Expose and serialize external state (`share/unshare` in Motoko, `candid::Encode` in Rust): `rbtree`, `heap`, `btreemap_rs`, `hashmap_rs`, `heap_rs`, `vector_rs`
>   + Use pre/post-upgrade hooks to convert data into an array: `hashmap`, `splay`, `triemap`, `buffer`, `imrc_hashmap_rs`
> * The stable benchmarks are much more expensive than their non-stable counterpart, because the stable memory API is much more expensive. The benefit is that they get fast upgrade. The upgrade still needs to parse the metadata when initializing the upgraded Wasm module.
> * `hashmap` uses amortized data structure. When the initial capacity is reached, it has to copy the whole array, thus the cost of `batch_put 50` is much higher than other data structures.
> * `btree` comes from [mops.one/stableheapbtreemap](https://mops.one/stableheapbtreemap).
> * `zhenya_hashmap` comes from [mops.one/map](https://mops.one/map).
> * `vector` comes from [mops.one/vector](https://mops.one/vector). Compare with `buffer`, `put` has better worst case time and space complexity ($O(\sqrt{n})$ vs $O(n)$); `get` has a slightly larger constant overhead.
> * `hashmap_rs` uses the `fxhash` crate, which is the same as `std::collections::HashMap`, but with a deterministic hasher. This ensures reproducible result.
> * `imrc_hashmap_rs` uses the `im-rc` crate, which is the immutable version hashmap in Rust.

