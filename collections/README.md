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
|hashmap|160_221|6_984_044_999|61_987_852|[288_670](hashmap_get.svg)|[5_536_856_410](hashmap_put.svg)|[310_195](hashmap_remove.svg)|[9_128_784_003](hashmap_upgrade.svg)|
|triemap|163_474|11_463_655_150|74_216_172|[222_926](triemap_get.svg)|[549_435](triemap_put.svg)|[540_205](triemap_remove.svg)|[13_075_158_546](triemap_upgrade.svg)|
|rbtree|158_149|5_979_229_900|57_996_060|[88_905](rbtree_get.svg)|[268_573](rbtree_put.svg)|[278_352](rbtree_remove.svg)|[5_771_880_608](rbtree_upgrade.svg)|
|splay|159_956|11_568_250_103|53_995_996|[552_014](splay_get.svg)|[581_765](splay_put.svg)|[810_321](splay_remove.svg)|[3_722_474_749](splay_upgrade.svg)|
|btree|187_897|8_224_242_789|31_104_012|[277_542](btree_get.svg)|[384_171](btree_put.svg)|[429_041](btree_remove.svg)|[2_517_941_583](btree_upgrade.svg)|
|zhenya_hashmap|160_509|2_201_622_562|22_773_100|[48_627](zhenya_hashmap_get.svg)|[61_839](zhenya_hashmap_put.svg)|[70_872](zhenya_hashmap_remove.svg)|[2_695_448_620](zhenya_hashmap_upgrade.svg)|
|btreemap_rs|477_612|1_651_590_463|27_590_656|[66_862](btreemap_rs_get.svg)|[112_477](btreemap_rs_put.svg)|[76_234](btreemap_rs_remove.svg)|[2_660_975_747](btreemap_rs_upgrade.svg)|
|imrc_hashmap_rs|479_773|2_392_906_831|244_973_568|[32_763](imrc_hashmap_rs_get.svg)|[163_245](imrc_hashmap_rs_put.svg)|[98_394](imrc_hashmap_rs_remove.svg)|[5_191_575_323](imrc_hashmap_rs_upgrade.svg)|
|hashmap_rs|467_997|403_296_648|73_138_176|[16_851](hashmap_rs_get.svg)|[21_680](hashmap_rs_put.svg)|[20_263](hashmap_rs_remove.svg)|[1_144_828_025](hashmap_rs_upgrade.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|heap|147_638|4_684_519_403|29_995_956|[511_505](heap_get.svg)|[186_471](heap_put.svg)|[487_225](heap_remove.svg)|[2_655_609_909](heap_upgrade.svg)|
|heap_rs|463_840|121_602_221|18_284_544|[51_661](heap_rs_get.svg)|[18_245](heap_rs_put.svg)|[51_802](heap_rs_remove.svg)|[440_739_988](heap_rs_upgrade.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|buffer|151_004|2_082_623|65_644|[73_092](buffer_get.svg)|[671_517](buffer_put.svg)|[127_592](buffer_remove.svg)|[2_474_639](buffer_upgrade.svg)|
|vector|152_551|1_588_260|24_580|[105_191](vector_get.svg)|[149_932](vector_put.svg)|[148_094](vector_remove.svg)|[3_844_445](vector_upgrade.svg)|
|vec_rs|459_655|265_683|1_310_720|[13_014](vec_rs_get.svg)|[25_363](vec_rs_put.svg)|[21_247](vec_rs_remove.svg)|[2_743_831](vec_rs_upgrade.svg)|

## Stable structures

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|btreemap_rs|477_612|70_026_986|2_555_904|[57_181](btreemap_rs_get.svg)|[86_494](btreemap_rs_put.svg)|[75_309](btreemap_rs_remove.svg)|[113_837_931](btreemap_rs_upgrade.svg)|
|btreemap_stable_rs|478_668|4_224_209_849|2_621_440|[2_528_769](btreemap_stable_rs_get.svg)|[4_605_548](btreemap_stable_rs_put.svg)|[7_817_380](btreemap_stable_rs_remove.svg)|[653_359](btreemap_stable_rs_upgrade.svg)|
|heap_rs|463_840|6_139_838|2_293_760|[44_362](heap_rs_get.svg)|[18_477](heap_rs_put.svg)|[44_345](heap_rs_remove.svg)|[23_149_372](heap_rs_upgrade.svg)|
|heap_stable_rs|451_018|279_422_369|458_752|[2_346_843](heap_stable_rs_get.svg)|[241_158](heap_stable_rs_put.svg)|[2_329_183](heap_stable_rs_remove.svg)|[653_433](heap_stable_rs_upgrade.svg)|
|vec_rs|459_655|2_866_886|2_228_224|[13_014](vec_rs_get.svg)|[14_113](vec_rs_put.svg)|[13_710](vec_rs_remove.svg)|[21_249_908](vec_rs_upgrade.svg)|
|vec_stable_rs|446_031|65_186_210|458_752|[58_992](vec_stable_rs_get.svg)|[77_387](vec_stable_rs_put.svg)|[79_383](vec_stable_rs_remove.svg)|[653_447](vec_stable_rs_upgrade.svg)|

> ## Environment
> * dfx 0.15.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.5.1
> * ic-wasm 0.6.0
