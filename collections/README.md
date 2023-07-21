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
|hashmap|152_580|1_195_632_150|9_102_052|[545_645](hashmap_get.svg)|[365_569_669](hashmap_put.svg)|[520_876](hashmap_remove.svg)|
|triemap|156_424|1_338_995_779|9_715_900|[459_710](triemap_get.svg)|[1_193_026](triemap_put.svg)|[686_569](triemap_remove.svg)|
|rbtree|153_258|1_115_533_975|8_902_160|[354_721](rbtree_get.svg)|[964_237](rbtree_put.svg)|[495_133](rbtree_remove.svg)|
|splay|152_693|1_323_550_652|8_702_096|[719_103](splay_get.svg)|[1_214_198](splay_put.svg)|[717_146](splay_remove.svg)|
|btree|180_227|1_222_588_229|7_556_172|[502_876](btree_get.svg)|[1_090_262](btree_put.svg)|[540_393](btree_remove.svg)|
|zhenya_hashmap|148_470|989_558_312|9_301_800|[334_927](zhenya_hashmap_get.svg)|[818_203](zhenya_hashmap_put.svg)|[335_264](zhenya_hashmap_remove.svg)|
|btreemap_rs|433_571|111_198_573|1_638_400|[57_817](btreemap_rs_get.svg)|[130_970](btreemap_rs_put.svg)|[60_911](btreemap_rs_remove.svg)|
|hashmap_rs|425_466|47_502_926|1_835_008|[17_683](hashmap_rs_get.svg)|[54_806](hashmap_rs_put.svg)|[18_297](hashmap_rs_remove.svg)|

## Priority queue

| |binary_size|heapify 50k|max mem|pop_min 50|put 50|
|--:|--:|--:|--:|--:|--:|
|heap|139_951|369_466_193|1_400_024|[334_365](heap_get.svg)|[397_474](heap_put.svg)|[335_750](heap_remove.svg)|
|heap_rs|404_308|5_222_946|819_200|[45_877](heap_rs_get.svg)|[18_643](heap_rs_put.svg)|[46_075](heap_rs_remove.svg)|

## MoVM

| |binary_size|generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|152_580|238_966_334|1_820_844|[543_937](hashmap_get.svg)|[73_525_914](hashmap_put.svg)|[518_626](hashmap_remove.svg)|
|hashmap_rs|425_466|9_801_108|950_272|[17_031](hashmap_rs_get.svg)|[54_134](hashmap_rs_put.svg)|[17_239](hashmap_rs_remove.svg)|
|imrc_hashmap_rs|433_888|25_575_323|1_572_864|[28_431](imrc_hashmap_rs_get.svg)|[149_379](imrc_hashmap_rs_put.svg)|[36_283](imrc_hashmap_rs_remove.svg)|
|movm_rs|1_712_199|1_089_653_746|2_654_208|[2_497_600](movm_rs_get.svg)|[6_977_084](movm_rs_put.svg)|[5_505_446](movm_rs_remove.svg)|
|movm_dynamic_rs|1_831_058|509_925_551|2_129_920|[2_045_671](movm_dynamic_rs_get.svg)|[2_754_013](movm_dynamic_rs_put.svg)|[2_043_229](movm_dynamic_rs_remove.svg)|
