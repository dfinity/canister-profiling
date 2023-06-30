# Collection libraries

Measure different collection libraries written in both Motoko and Rust. 
The library names with `_rs` suffix are written in Rust; the rest are written in Motoko.

We use the same random number generator with fixed seed to ensure that all collections contain
the same elements, and the queries are exactly the same. Below we explain the measurements of each column in the table:

* generate 50k. Insert 50k Nat32 integers into the collection. For Motoko collections, it usually triggers the GC; the rest of the column are not likely to trigger GC.
* max mem. For Motoko, it reports `rts_max_live_size` after `generate` call; For Rust, it reports the Wasm's memory page * 32Kb.
* batch_get 50. Find 50 elements from the collection.
* batch_put 50. Insert 50 elements to the collection.
* batch_remove 50. Remove 50 elements from the collection.

## **💎 Takeaways**

* The platform only charges for instruction count. Data structures which make use of caching and locality have no impact on the cost.
* We have a limit on the maximal cycles per round. This means asymptotic behavior doesn't matter much. We care more about the performance up to a fixed N. In the extreme cases, you may see an `O(10000 nlogn)` algorithm hitting the limit, while an `O(n^2)` algorithm runs just fine.
* Amortized algorithms/GC may need to be more eager to avoid hitting the cycle limit on a particular round.
* Rust costs more cycles to process complicated Candid data, but it is more efficient in performing core computations.

> **Note**
>
> * The Candid interface of the benchmark is minimal, therefore the serialization cost is negligible in this measurement.
> * Due to the instrumentation overhead and cycle limit, we cannot profile computations with large collections. Hopefully, when deterministic time slicing is ready, we can measure the performance on larger memory footprint.
> * `hashmap` uses amortized data structure. When the initial capacity is reached, it has to copy the whole array, thus the cost of `batch_put 50` is much higher than other data structures.
> * `hashmap_rs` uses the `fxhash` crate, which is the same as `std::collections::HashMap`, but with a deterministic hasher. This ensures reproducible result.
> * `btree` comes from [Byron Becker's stable BTreeMap library](https://github.com/canscale/StableHeapBTreeMap).
> * `zhenya_hashmap` comes from [Zhenya Usenko's stable HashMap library](https://github.com/ZhenyaUsenko/motoko-hash-map).
> * The MoVM table measures the performance of an experimental implementation of Motoko interpreter. External developers can ignore this table for now.

## Map

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|169_982|2_097_113_506|9_102_052|[1_115_399](hashmap_get.svg)|[609_254_124](hashmap_put.svg)|[1_056_869](hashmap_remove.svg)|
|triemap|174_030|2_020_134_416|9_715_900|[773_637](triemap_get.svg)|[1_853_794](triemap_put.svg)|[1_033_460](triemap_remove.svg)|
|rbtree|171_127|1_797_995_532|8_902_160|[670_401](rbtree_get.svg)|[1_623_975](rbtree_put.svg)|[859_340](rbtree_remove.svg)|
|splay|170_477|2_040_395_523|8_702_096|[1_102_393](splay_get.svg)|[1_915_542](splay_put.svg)|[1_103_332](splay_remove.svg)|
|btree|198_636|1_875_401_612|7_556_172|[813_525](btree_get.svg)|[1_718_273](btree_put.svg)|[862_047](btree_remove.svg)|
|zhenya_hashmap|165_325|1_642_423_605|9_301_800|[647_832](zhenya_hashmap_get.svg)|[1_447_024](zhenya_hashmap_put.svg)|[652_030](zhenya_hashmap_remove.svg)|
|btreemap_rs|438_979|112_676_543|1_638_400|[59_465](btreemap_rs_get.svg)|[133_080](btreemap_rs_put.svg)|[60_509](btreemap_rs_remove.svg)|
|hashmap_rs|428_466|49_363_168|1_835_008|[19_572](hashmap_rs_get.svg)|[58_237](hashmap_rs_put.svg)|[20_805](hashmap_rs_remove.svg)|

## Priority queue

| |binary_size|heapify 50k|mem|pop_min 50|put 50|
|--:|--:|--:|--:|--:|--:|
|heap|156_998|688_335_838|1_400_024|[338_619](heap_get.svg)|[711_943](heap_put.svg)|[340_032](heap_remove.svg)|
|heap_rs|406_219|4_975_528|819_200|[48_902](heap_rs_get.svg)|[20_578](heap_rs_put.svg)|[49_090](heap_rs_remove.svg)|

## MoVM

| |binary_size|generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|169_982|419_486_900|1_820_844|[1_113_679](hashmap_get.svg)|[122_781_037](hashmap_put.svg)|[1_054_639](hashmap_remove.svg)|
|hashmap_rs|428_466|10_178_230|950_272|[18_903](hashmap_rs_get.svg)|[57_565](hashmap_rs_put.svg)|[19_747](hashmap_rs_remove.svg)|
|imrc_hashmap_rs|435_292|19_062_328|1_572_864|[29_764](imrc_hashmap_rs_get.svg)|[113_802](imrc_hashmap_rs_put.svg)|[36_791](imrc_hashmap_rs_remove.svg)|
|movm_rs|1_760_914|999_676_261|2_654_208|[2_424_874](movm_rs_get.svg)|[6_357_705](movm_rs_put.svg)|[5_013_896](movm_rs_remove.svg)|
|movm_dynamic_rs|1_943_858|485_763_587|2_129_920|[1_909_424](movm_dynamic_rs_get.svg)|[2_642_175](movm_dynamic_rs_put.svg)|[1_907_002](movm_dynamic_rs_remove.svg)|
