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
|hashmap|196_369|2_387_017_574|9_102_052|[1_293_415](hashmap_get.svg)|[689_296_283](hashmap_put.svg)|[1_225_104](hashmap_remove.svg)|
|triemap|202_071|2_289_517_688|9_715_900|[893_026](triemap_get.svg)|[2_115_311](triemap_put.svg)|[1_191_446](triemap_remove.svg)|
|rbtree|199_849|2_035_251_413|8_902_160|[793_297](rbtree_get.svg)|[1_850_762](rbtree_put.svg)|[1_001_355](rbtree_remove.svg)|
|splay|198_235|2_311_784_134|8_702_096|[1_265_818](splay_get.svg)|[2_182_532](splay_put.svg)|[1_267_265](splay_remove.svg)|
|btree|235_657|2_126_392_096|7_556_172|[941_598](btree_get.svg)|[1_959_940](btree_put.svg)|[996_986](btree_remove.svg)|
|zhenya_hashmap|190_566|1_855_281_618|9_301_800|[746_302](zhenya_hashmap_get.svg)|[1_651_710](zhenya_hashmap_put.svg)|[752_598](zhenya_hashmap_remove.svg)|
|btreemap_rs|516_072|123_800_095|1_638_400|[59_721](btreemap_rs_get.svg)|[140_267](btreemap_rs_put.svg)|[62_087](btreemap_rs_remove.svg)|
|hashmap_rs|504_134|53_234_034|1_835_008|[21_361](hashmap_rs_get.svg)|[63_796](hashmap_rs_put.svg)|[22_778](hashmap_rs_remove.svg)|

## Priority queue

| |binary_size|heapify 50k|mem|pop_min 50|put 50|
|--:|--:|--:|--:|--:|--:|
|heap|181_817|793_443_407|1_400_024|[387_748](heap_get.svg)|[824_203](heap_put.svg)|[389_316](heap_remove.svg)|
|heap_rs|475_112|5_041_620|819_200|[53_561](heap_rs_get.svg)|[22_281](heap_rs_put.svg)|[53_738](heap_rs_remove.svg)|

## MoVM

| |binary_size|generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|196_369|477_464_161|1_820_844|[1_291_442](hashmap_get.svg)|[138_897_496](hashmap_put.svg)|[1_222_518](hashmap_remove.svg)|
|hashmap_rs|504_134|10_964_340|950_272|[20_676](hashmap_rs_get.svg)|[63_102](hashmap_rs_put.svg)|[21_668](hashmap_rs_remove.svg)|
|imrc_hashmap_rs|516_504|19_861_761|1_572_864|[31_820](imrc_hashmap_rs_get.svg)|[120_208](imrc_hashmap_rs_put.svg)|[37_919](imrc_hashmap_rs_remove.svg)|
|movm_rs|2_033_726|1_098_781_035|2_654_208|[2_743_966](movm_rs_get.svg)|[6_943_650](movm_rs_put.svg)|[5_416_733](movm_rs_remove.svg)|
|movm_dynamic_rs|2_228_378|555_576_815|2_129_920|[2_186_795](movm_dynamic_rs_get.svg)|[3_010_179](movm_dynamic_rs_put.svg)|[2_166_068](movm_dynamic_rs_remove.svg)|
