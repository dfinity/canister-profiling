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
* upgrade. Upgrade the canister with the same Wasm module. For non-stable benchmarks, the map state is persisted by serializing and deserializing states into stable memory. For stable benchmarks, the upgrade takes no cycles, as the state is already in the stable memory.

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


## Map

| |binary_size|generate 1m|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|hashmap|194_129|8_193_819_060|56_000_256|[342_788](hashmap_get.svg)|[6_469_781_020](hashmap_put.svg)|[368_431](hashmap_remove.svg)|[10_766_389_949](hashmap_upgrade.svg)|
|triemap|199_671|13_670_187_584|68_228_576|[252_704](triemap_get.svg)|[657_887](triemap_put.svg)|[648_184](triemap_remove.svg)|[15_537_338_607](triemap_upgrade.svg)|
|orderedmap|198_472|5_918_271_186|36_000_524|[120_106](orderedmap_get.svg)|[287_536](orderedmap_put.svg)|[326_469](orderedmap_remove.svg)|[4_583_353_795](orderedmap_upgrade.svg)|
|rbtree|190_190|6_993_676_959|52_000_464|[116_417](rbtree_get.svg)|[317_299](rbtree_put.svg)|[330_296](rbtree_remove.svg)|[6_988_883_792](rbtree_upgrade.svg)|
|splay|194_749|13_052_525_320|48_000_400|[625_852](splay_get.svg)|[657_023](splay_put.svg)|[920_272](splay_remove.svg)|[4_321_904_232](splay_upgrade.svg)|
|btree|234_430|10_220_059_976|25_108_416|[357_581](btree_get.svg)|[485_463](btree_put.svg)|[539_509](btree_remove.svg)|[2_906_462_612](btree_upgrade.svg)|
|zhenya_hashmap|192_961|2_361_649_032|16_777_504|[58_299](zhenya_hashmap_get.svg)|[66_594](zhenya_hashmap_put.svg)|[79_776](zhenya_hashmap_remove.svg)|[3_084_236_540](zhenya_hashmap_upgrade.svg)|
|btreemap_rs|611_851|1_809_789_841|27_590_656|[74_098](btreemap_rs_get.svg)|[124_626](btreemap_rs_put.svg)|[85_214](btreemap_rs_remove.svg)|[3_208_130_200](btreemap_rs_upgrade.svg)|
|imrc_hashmap_rs|613_202|2_634_915_707|244_908_032|[35_894](imrc_hashmap_rs_get.svg)|[198_252](imrc_hashmap_rs_put.svg)|[96_520](imrc_hashmap_rs_remove.svg)|[6_383_840_797](imrc_hashmap_rs_upgrade.svg)|
|hashmap_rs|601_477|438_103_157|73_138_176|[20_788](hashmap_rs_get.svg)|[25_678](hashmap_rs_put.svg)|[23_645](hashmap_rs_remove.svg)|[1_545_701_419](hashmap_rs_upgrade.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|heap|171_060|5_557_564_409|24_000_360|[621_758](heap_get.svg)|[227_293](heap_put.svg)|[592_698](heap_remove.svg)|[3_240_817_647](heap_upgrade.svg)|
|heap_rs|596_953|143_262_451|18_284_544|[58_563](heap_rs_get.svg)|[21_622](heap_rs_put.svg)|[58_466](heap_rs_remove.svg)|[647_923_463](heap_rs_upgrade.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|buffer|178_117|2_601_290|65_652|[95_575](buffer_get.svg)|[803_545](buffer_put.svg)|[173_575](buffer_remove.svg)|[3_146_728](buffer_upgrade.svg)|
|vector|175_919|1_952_750|24_588|[126_199](vector_get.svg)|[186_554](vector_put.svg)|[176_192](vector_remove.svg)|[4_780_320](vector_upgrade.svg)|
|vec_rs|588_969|287_516|1_376_256|[16_494](vec_rs_get.svg)|[30_089](vec_rs_put.svg)|[22_346](vec_rs_remove.svg)|[3_806_788](vec_rs_upgrade.svg)|

## Stable structures

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|btreemap_rs|611_851|77_021_026|2_555_904|[63_656](btreemap_rs_get.svg)|[96_504](btreemap_rs_put.svg)|[84_265](btreemap_rs_remove.svg)|[139_792_280](btreemap_rs_upgrade.svg)|
|btreemap_stable_rs|616_876|4_773_834_814|2_031_616|[2_893_685](btreemap_stable_rs_get.svg)|[5_266_123](btreemap_stable_rs_put.svg)|[8_870_300](btreemap_stable_rs_remove.svg)|[729_405](btreemap_stable_rs_upgrade.svg)|
|heap_rs|596_953|7_230_201|2_293_760|[50_652](heap_rs_get.svg)|[21_870](heap_rs_put.svg)|[50_383](heap_rs_remove.svg)|[33_581_842](heap_rs_upgrade.svg)|
|heap_stable_rs|576_040|283_742_492|458_752|[2_526_262](heap_stable_rs_get.svg)|[246_537](heap_stable_rs_put.svg)|[2_506_863](heap_stable_rs_remove.svg)|[729_375](heap_stable_rs_upgrade.svg)|
|vec_rs|588_969|3_077_883|2_293_760|[16_494](vec_rs_get.svg)|[17_489](vec_rs_put.svg)|[16_734](vec_rs_remove.svg)|[31_302_411](vec_rs_upgrade.svg)|
|vec_stable_rs|572_835|63_993_021|458_752|[66_549](vec_stable_rs_get.svg)|[80_266](vec_stable_rs_put.svg)|[85_639](vec_stable_rs_remove.svg)|[729_377](vec_stable_rs_upgrade.svg)|

> ## Environment
> * dfx 0.24.0
> * Motoko compiler 0.13.3 (source ff4il9yc-sfakbpl1-8z4dm2d6-ybdjncj7)
> * rustc 1.81.0 (eeb90cda1 2024-09-04)
> * ic-repl 0.7.6
> * ic-wasm 0.9.0
