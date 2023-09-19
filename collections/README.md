# Collection libraries

Measure different collection libraries written in both Motoko and Rust. 
The library names with `_rs` suffix are written in Rust; the rest are written in Motoko.

We use the same random number generator with fixed seed to ensure that all collections contain
the same elements, and the queries are exactly the same. Below we explain the measurements of each column in the table:

* generate 1m. Insert 1m Nat64 integers into the collection. For Motoko collections, it usually triggers the GC; the rest of the column are not likely to trigger GC.
* max mem. For Motoko, it reports `rts_max_heap_size` after `generate` call; For Rust, it reports the Wasm's memory page * 32Kb.
* batch_get 50. Find 50 elements from the collection.
* batch_put 50. Insert 50 elements to the collection.
* batch_remove 50. Remove 50 elements from the collection.

## **💎 Takeaways**

* The platform only charges for instruction count. Data structures which make use of caching and locality have no impact on the cost.
* We have a limit on the maximal cycles per round. This means asymptotic behavior doesn't matter much. We care more about the performance up to a fixed N. In the extreme cases, you may see an $O(10000 n\log n)$ algorithm hitting the limit, while an $O(n^2)$ algorithm runs just fine.
* Amortized algorithms/GC may need to be more eager to avoid hitting the cycle limit on a particular round.
* Rust costs more cycles to process complicated Candid data, but it is more efficient in performing core computations.

> **Note**
>
> * The Candid interface of the benchmark is minimal, therefore the serialization cost is negligible in this measurement.
> * Due to the instrumentation overhead and cycle limit, we cannot profile computations with large collections. Hopefully, when deterministic time slicing is ready, we can measure the performance on larger memory footprint.
> * `hashmap` uses amortized data structure. When the initial capacity is reached, it has to copy the whole array, thus the cost of `batch_put 50` is much higher than other data structures.
> * `btree` comes from [mops.one/stableheapbtreemap](https://mops.one/stableheapbtreemap).
> * `zhenya_hashmap` comes from [mops.one/map](https://mops.one/map).
> * `vector` comes from [mops.one/vector](https://mops.one/vector). Compare with `buffer`, `put` has better worst case time and space complexity ($O(\sqrt{n})$ vs $O(n)$); `get` has a slightly larger constant overhead.
> * `hashmap_rs` uses the `fxhash` crate, which is the same as `std::collections::HashMap`, but with a deterministic hasher. This ensures reproducible result.
> * `imrc_hashmap_rs` uses the `im-rc` crate, which is the immutable version hashmap in Rust.


## Map

| |binary_size|generate 1m|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|138_275|6_974_058_129|61_987_732|[288_202](hashmap_get.svg)|[5_527_868_856](hashmap_put.svg)|[309_728](hashmap_remove.svg)|
|triemap|139_765|11_432_083_637|74_216_052|[222_825](triemap_get.svg)|[547_701](triemap_put.svg)|[539_052](triemap_remove.svg)|
|rbtree|140_562|5_979_229_508|57_995_940|[88_905](rbtree_get.svg)|[268_573](rbtree_put.svg)|[278_352](rbtree_remove.svg)|
|splay|136_342|11_568_250_621|53_995_876|[551_926](splay_get.svg)|[581_651](splay_put.svg)|[810_220](splay_remove.svg)|
|btree|181_449|8_224_241_444|31_103_892|[277_542](btree_get.svg)|[384_171](btree_put.svg)|[429_041](btree_remove.svg)|
|zhenya_hashmap|153_793|2_201_621_425|22_772_980|[48_627](zhenya_hashmap_get.svg)|[61_839](zhenya_hashmap_put.svg)|[70_872](zhenya_hashmap_remove.svg)|
|btreemap_rs|418_496|1_654_114_123|13_762_560|[66_828](btreemap_rs_get.svg)|[112_500](btreemap_rs_put.svg)|[81_246](btreemap_rs_remove.svg)|
|imrc_hashmap_rs|418_054|2_386_381_040|122_454_016|[32_841](imrc_hashmap_rs_get.svg)|[162_760](imrc_hashmap_rs_put.svg)|[98_464](imrc_hashmap_rs_remove.svg)|
|hashmap_rs|411_843|402_296_785|36_536_320|[16_635](hashmap_rs_get.svg)|[21_539](hashmap_rs_put.svg)|[19_990](hashmap_rs_remove.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|
|--:|--:|--:|--:|--:|--:|
|heap|132_227|4_684_517_324|29_995_836|[511_499](heap_get.svg)|[186_465](heap_put.svg)|[487_206](heap_remove.svg)|
|heap_rs|409_392|123_102_351|9_109_504|[53_320](heap_rs_get.svg)|[18_140](heap_rs_put.svg)|[53_545](heap_rs_remove.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|
|--:|--:|--:|--:|--:|--:|--:|
|buffer|139_908|2_082_623|65_508|[73_092](buffer_get.svg)|[671_517](buffer_put.svg)|[127_592](buffer_remove.svg)|
|vector|138_344|1_728_571|24_764|[121_219](vector_get.svg)|[163_947](vector_put.svg)|[161_609](vector_remove.svg)|
|vec_rs|408_280|265_791|655_360|[12_840](vec_rs_get.svg)|[25_269](vec_rs_put.svg)|[21_153](vec_rs_remove.svg)|
