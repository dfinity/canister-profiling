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
|hashmap|160_407|8_550_261_900|61_987_852|[349_808](hashmap_get.svg)|[6_641_222_848](hashmap_put.svg)|[377_790](hashmap_remove.svg)|[11_273_695_870](hashmap_upgrade.svg)|
|triemap|163_606|15_268_684_428|74_216_172|[301_412](triemap_get.svg)|[737_508](triemap_put.svg)|[722_627](triemap_remove.svg)|[17_302_961_961](triemap_upgrade.svg)|
|rbtree|158_225|7_665_886_603|57_996_060|[115_637](rbtree_get.svg)|[346_274](rbtree_put.svg)|[370_932](rbtree_remove.svg)|[7_231_296_002](rbtree_upgrade.svg)|
|splay|160_055|15_388_999_493|53_995_996|[738_550](splay_get.svg)|[777_813](splay_put.svg)|[1_077_553](splay_remove.svg)|[4_832_227_514](splay_upgrade.svg)|
|btree|188_004|11_040_703_048|31_104_012|[376_209](btree_get.svg)|[519_468](btree_put.svg)|[577_253](btree_remove.svg)|[3_162_844_776](btree_upgrade.svg)|
|zhenya_hashmap|160_784|2_838_455_412|22_773_100|[66_353](zhenya_hashmap_get.svg)|[84_294](zhenya_hashmap_put.svg)|[96_614](zhenya_hashmap_remove.svg)|[3_353_572_476](zhenya_hashmap_upgrade.svg)|
|btreemap_rs|478_653|1_797_168_137|27_590_656|[75_573](btreemap_rs_get.svg)|[125_437](btreemap_rs_put.svg)|[86_323](btreemap_rs_remove.svg)|[2_941_065_080](btreemap_rs_upgrade.svg)|
|imrc_hashmap_rs|482_783|2_584_652_919|244_973_568|[38_439](imrc_hashmap_rs_get.svg)|[179_288](imrc_hashmap_rs_put.svg)|[115_588](imrc_hashmap_rs_remove.svg)|[5_796_576_276](imrc_hashmap_rs_upgrade.svg)|
|hashmap_rs|469_075|433_765_793|73_138_176|[21_856](hashmap_rs_get.svg)|[26_958](hashmap_rs_put.svg)|[25_223](hashmap_rs_remove.svg)|[1_293_479_144](hashmap_rs_upgrade.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|heap|147_908|6_393_606_585|29_995_956|[701_835](heap_get.svg)|[258_841](heap_put.svg)|[668_731](heap_remove.svg)|[3_337_783_210](heap_upgrade.svg)|
|heap_rs|462_827|138_669_875|18_284_544|[57_564](heap_rs_get.svg)|[23_346](heap_rs_put.svg)|[57_696](heap_rs_remove.svg)|[511_961_256](heap_rs_upgrade.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|buffer|151_225|2_811_683|65_644|[109_527](buffer_get.svg)|[884_994](buffer_put.svg)|[178_027](buffer_remove.svg)|[3_206_695](buffer_upgrade.svg)|
|vector|152_845|2_228_708|24_580|[146_173](vector_get.svg)|[212_398](vector_put.svg)|[203_951](vector_remove.svg)|[4_810_168](vector_upgrade.svg)|
|vec_rs|460_616|289_093|1_310_720|[17_300](vec_rs_get.svg)|[30_623](vec_rs_put.svg)|[25_759](vec_rs_remove.svg)|[3_171_850](vec_rs_upgrade.svg)|

## Stable structures

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|btreemap_rs|478_653|76_392_041|2_555_904|[65_131](btreemap_rs_get.svg)|[97_327](btreemap_rs_put.svg)|[85_332](btreemap_rs_remove.svg)|[126_467_483](btreemap_rs_upgrade.svg)|
|btreemap_stable_rs|488_655|5_255_681_694|2_031_616|[3_167_281](btreemap_stable_rs_get.svg)|[5_784_578](btreemap_stable_rs_put.svg)|[9_888_420](btreemap_stable_rs_remove.svg)|[731_129](btreemap_stable_rs_upgrade.svg)|
|heap_rs|462_827|7_001_771|2_293_760|[50_073](heap_rs_get.svg)|[23_594](heap_rs_put.svg)|[50_045](heap_rs_remove.svg)|[26_819_762](heap_rs_upgrade.svg)|
|heap_stable_rs|450_750|319_633_530|458_752|[2_674_744](heap_stable_rs_get.svg)|[278_372](heap_stable_rs_put.svg)|[2_654_546](heap_stable_rs_remove.svg)|[731_276](heap_stable_rs_upgrade.svg)|
|vec_rs|460_616|3_079_437|2_228_224|[17_300](vec_rs_get.svg)|[18_473](vec_rs_put.svg)|[18_000](vec_rs_remove.svg)|[24_772_373](vec_rs_upgrade.svg)|
|vec_stable_rs|448_692|75_145_339|458_752|[70_326](vec_stable_rs_get.svg)|[91_522](vec_stable_rs_put.svg)|[93_718](vec_stable_rs_remove.svg)|[731_289](vec_stable_rs_upgrade.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
