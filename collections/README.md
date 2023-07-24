# Collection libraries

Measure different collection libraries written in both Motoko and Rust. 
The library names with `_rs` suffix are written in Rust; the rest are written in Motoko.

We use the same random number generator with fixed seed to ensure that all collections contain
the same elements, and the queries are exactly the same. Below we explain the measurements of each column in the table:

* generate 1m. Insert 1m Nat64 integers into the collection. For Motoko collections, it usually triggers the GC; the rest of the column are not likely to trigger GC.
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
> * `btree` comes from [Byron Becker's stable BTreeMap library](https://github.com/canscale/StableHeapBTreeMap).
> * `zhenya_hashmap` comes from [Zhenya Usenko's stable HashMap library](https://github.com/ZhenyaUsenko/motoko-hash-map).
> * `hashmap_rs` uses the `fxhash` crate, which is the same as `std::collections::HashMap`, but with a deterministic hasher. This ensures reproducible result.
> * `imrc_hashmap_rs` uses the `im-rc` crate, which is the immutable version hashmap in Rust.
> * The MoVM table measures the performance of an experimental implementation of Motoko interpreter. External developers can ignore this table for now.

## Map

| |binary_size|generate 1m|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|--:|
|hashmap|133_828|6_960_077_358|61_987_708|[287_469](hashmap_get.svg)|[5_515_887_135](hashmap_put.svg)|[308_972](hashmap_remove.svg)|
|triemap|135_316|11_431_084_368|74_215_992|[222_768](triemap_get.svg)|[547_650](triemap_put.svg)|[538_998](triemap_remove.svg)|
|rbtree|136_114|5_979_229_531|57_995_880|[88_900](rbtree_get.svg)|[268_568](rbtree_put.svg)|[278_334](rbtree_remove.svg)|
|splay|131_868|11_568_250_397|53_995_816|[551_921](splay_get.svg)|[581_659](splay_put.svg)|[810_215](splay_remove.svg)|
|btree|176_459|8_224_241_532|31_103_868|[277_537](btree_get.svg)|[384_166](btree_put.svg)|[429_036](btree_remove.svg)|
|zhenya_hashmap|141_855|2_756_209_728|65_987_456|[68_392](zhenya_hashmap_get.svg)|[83_100](zhenya_hashmap_put.svg)|[93_270](zhenya_hashmap_remove.svg)|
|btreemap_rs|413_478|1_649_709_879|13_762_560|[66_814](btreemap_rs_get.svg)|[112_263](btreemap_rs_put.svg)|[81_263](btreemap_rs_remove.svg)|
|imrc_hashmap_rs|413_588|2_385_702_121|122_454_016|[32_846](imrc_hashmap_rs_get.svg)|[162_715](imrc_hashmap_rs_put.svg)|[98_494](imrc_hashmap_rs_remove.svg)|
|hashmap_rs|406_096|392_593_368|36_536_320|[16_498](hashmap_rs_get.svg)|[20_863](hashmap_rs_put.svg)|[19_973](hashmap_rs_remove.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|
|--:|--:|--:|--:|--:|--:|
|heap|127_748|4_684_517_789|29_995_812|[511_494](heap_get.svg)|[186_460](heap_put.svg)|[487_201](heap_remove.svg)|
|heap_rs|403_925|123_102_482|9_109_504|[53_320](heap_rs_get.svg)|[18_138](heap_rs_put.svg)|[53_543](heap_rs_remove.svg)|
