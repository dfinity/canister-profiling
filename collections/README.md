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
|hashmap|152_580|2_100_253_194|9_102_052|[1_113_874](hashmap_get.svg)|[612_491_312](hashmap_put.svg)|[1_053_817](hashmap_remove.svg)|
|triemap|156_424|1_997_549_742|9_715_900|[772_294](triemap_get.svg)|[1_823_303](triemap_put.svg)|[1_003_195](triemap_remove.svg)|
|rbtree|153_386|1_774_086_561|8_902_160|[671_400](rbtree_get.svg)|[1_594_501](rbtree_put.svg)|[815_717](rbtree_remove.svg)|
|splay|152_852|1_987_012_034|8_702_096|[1_037_197](splay_get.svg)|[1_850_109](splay_put.svg)|[1_039_266](splay_remove.svg)|
|btree|181_171|1_882_440_509|7_556_172|[816_260](btree_get.svg)|[1_721_944](btree_put.svg)|[858_619](btree_remove.svg)|
|zhenya_hashmap|148_470|1_648_109_546|9_301_800|[647_511](zhenya_hashmap_get.svg)|[1_448_480](zhenya_hashmap_put.svg)|[651_890](zhenya_hashmap_remove.svg)|
|btreemap_rs|438_970|112_676_543|1_638_400|[59_465](btreemap_rs_get.svg)|[133_080](btreemap_rs_put.svg)|[60_509](btreemap_rs_remove.svg)|
|hashmap_rs|428_457|49_363_168|1_835_008|[19_572](hashmap_rs_get.svg)|[58_237](hashmap_rs_put.svg)|[20_805](hashmap_rs_remove.svg)|

## Priority queue

| |binary_size|heapify 50k|mem|pop_min 50|put 50|
|--:|--:|--:|--:|--:|--:|
|heap|139_951|687_408_600|1_400_024|[334_365](heap_get.svg)|[710_084](heap_put.svg)|[335_776](heap_remove.svg)|
|heap_rs|406_210|4_975_528|819_200|[48_902](heap_rs_get.svg)|[20_578](heap_rs_put.svg)|[49_090](heap_rs_remove.svg)|

## MoVM

| |binary_size|generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|152_580|420_114_983|1_820_844|[1_112_166](hashmap_get.svg)|[123_430_217](hashmap_put.svg)|[1_051_567](hashmap_remove.svg)|
|hashmap_rs|428_457|10_178_230|950_272|[18_903](hashmap_rs_get.svg)|[57_565](hashmap_rs_put.svg)|[19_747](hashmap_rs_remove.svg)|
|imrc_hashmap_rs|435_283|19_062_328|1_572_864|[29_764](imrc_hashmap_rs_get.svg)|[113_802](imrc_hashmap_rs_put.svg)|[36_791](imrc_hashmap_rs_remove.svg)|
|movm_rs|1_760_905|999_676_261|2_654_208|[2_424_874](movm_rs_get.svg)|[6_357_705](movm_rs_put.svg)|[5_013_896](movm_rs_remove.svg)|
|movm_dynamic_rs|1_943_849|485_763_587|2_129_920|[1_909_424](movm_dynamic_rs_get.svg)|[2_642_175](movm_dynamic_rs_put.svg)|[1_907_002](movm_dynamic_rs_remove.svg)|
