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
|hashmap|196_227|2_387_017_574|9_102_052|[1_293_015](hashmap_get.svg)|[689_295_883](hashmap_put.svg)|[1_224_704](hashmap_remove.svg)|
|triemap|201_786|2_286_509_386|9_715_900|[891_925](triemap_get.svg)|[2_111_535](triemap_put.svg)|[1_187_671](triemap_remove.svg)|
|rbtree|198_958|2_024_735_614|8_902_160|[787_768](rbtree_get.svg)|[1_839_147](rbtree_put.svg)|[991_630](rbtree_remove.svg)|
|splay|197_868|2_305_505_782|8_702_096|[1_258_328](splay_get.svg)|[2_175_053](splay_put.svg)|[1_259_845](splay_remove.svg)|
|btree|235_337|2_122_255_521|7_556_172|[936_630](btree_get.svg)|[1_954_939](btree_put.svg)|[991_671](btree_remove.svg)|
|zhenya_hashmap|190_491|1_855_281_618|9_301_800|[745_902](zhenya_hashmap_get.svg)|[1_651_310](zhenya_hashmap_put.svg)|[752_198](zhenya_hashmap_remove.svg)|
|btreemap_rs|514_775|115_994_744|1_638_400|[59_433](btreemap_rs_get.svg)|[137_855](btreemap_rs_put.svg)|[61_795](btreemap_rs_remove.svg)|
|hashmap_rs|502_772|53_333_947|1_835_008|[21_070](hashmap_rs_get.svg)|[63_601](hashmap_rs_put.svg)|[22_484](hashmap_rs_remove.svg)|

## Priority queue

| |binary_size|heapify 50k|mem|pop_min 50|put 50|
|--:|--:|--:|--:|--:|--:|
|heap|181_726|793_253_862|1_400_024|[385_321](heap_get.svg)|[822_756](heap_put.svg)|[386_887](heap_remove.svg)|
|heap_rs|473_458|5_041_433|819_200|[53_243](heap_rs_get.svg)|[22_092](heap_rs_put.svg)|[53_420](heap_rs_remove.svg)|

## MoVM

| |binary_size|generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|196_227|477_464_161|1_820_844|[1_291_042](hashmap_get.svg)|[138_897_096](hashmap_put.svg)|[1_222_118](hashmap_remove.svg)|
|hashmap_rs|502_772|10_984_247|950_272|[20_385](hashmap_rs_get.svg)|[62_907](hashmap_rs_put.svg)|[21_374](hashmap_rs_remove.svg)|
|imrc_hashmap_rs|513_980|19_919_391|1_572_864|[31_519](imrc_hashmap_rs_get.svg)|[120_207](imrc_hashmap_rs_put.svg)|[37_618](imrc_hashmap_rs_remove.svg)|
|movm_rs|2_092_441|1_017_324_475|2_654_208|[2_494_635](movm_rs_get.svg)|[6_477_172](movm_rs_put.svg)|[5_106_080](movm_rs_remove.svg)|
|movm_dynamic_rs|2_295_206|496_274_407|2_129_920|[1_951_981](movm_dynamic_rs_get.svg)|[2_709_572](movm_dynamic_rs_put.svg)|[1_950_006](movm_dynamic_rs_remove.svg)|
