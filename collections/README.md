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
|hashmap|188_910|8_370_838_990|61_987_852|[344_911](hashmap_get.svg)|[6_593_215_386](hashmap_put.svg)|[371_223](hashmap_remove.svg)|[11_026_881_645](hashmap_upgrade.svg)|
|triemap|194_820|13_855_040_241|74_216_172|[254_589](triemap_get.svg)|[661_468](triemap_put.svg)|[650_780](triemap_remove.svg)|[15_817_667_776](triemap_upgrade.svg)|
|rbtree|185_823|7_127_314_751|57_996_060|[114_300](rbtree_get.svg)|[318_392](rbtree_put.svg)|[328_237](rbtree_remove.svg)|[7_169_324_321](rbtree_upgrade.svg)|
|splay|189_838|13_247_301_683|53_995_996|[628_581](splay_get.svg)|[661_619](splay_put.svg)|[921_933](splay_remove.svg)|[4_567_871_409](splay_upgrade.svg)|
|btree|229_184|10_266_012_845|31_104_012|[353_622](btree_get.svg)|[482_125](btree_put.svg)|[533_935](btree_remove.svg)|[3_134_166_577](btree_upgrade.svg)|
|zhenya_hashmap|188_597|2_570_553_414|22_773_100|[60_196](zhenya_hashmap_get.svg)|[70_137](zhenya_hashmap_put.svg)|[82_453](zhenya_hashmap_remove.svg)|[3_305_570_068](zhenya_hashmap_upgrade.svg)|
|btreemap_rs|471_597|1_797_168_136|27_525_120|[75_572](btreemap_rs_get.svg)|[125_436](btreemap_rs_put.svg)|[86_322](btreemap_rs_remove.svg)|[2_941_064_929](btreemap_rs_upgrade.svg)|
|imrc_hashmap_rs|477_125|2_584_652_896|244_973_568|[38_416](imrc_hashmap_rs_get.svg)|[179_265](imrc_hashmap_rs_put.svg)|[115_565](imrc_hashmap_rs_remove.svg)|[5_796_576_120](imrc_hashmap_rs_upgrade.svg)|
|hashmap_rs|464_990|433_765_792|73_072_640|[21_855](hashmap_rs_get.svg)|[26_957](hashmap_rs_put.svg)|[25_222](hashmap_rs_remove.svg)|[1_293_478_901](hashmap_rs_upgrade.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|heap|166_808|5_697_879_935|29_995_956|[621_338](heap_get.svg)|[228_674](heap_put.svg)|[592_198](heap_remove.svg)|[3_309_814_038](heap_upgrade.svg)|
|heap_rs|459_314|138_669_874|18_219_008|[57_563](heap_rs_get.svg)|[23_345](heap_rs_put.svg)|[57_695](heap_rs_remove.svg)|[511_961_183](heap_rs_upgrade.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|buffer|173_215|2_570_947|65_644|[95_490](buffer_get.svg)|[800_452](buffer_put.svg)|[170_490](buffer_remove.svg)|[3_061_307](buffer_upgrade.svg)|
|vector|171_563|1_920_997|24_580|[126_114](vector_get.svg)|[183_385](vector_put.svg)|[175_981](vector_remove.svg)|[4_695_522](vector_upgrade.svg)|
|vec_rs|453_413|289_090|1_310_720|[17_298](vec_rs_get.svg)|[30_623](vec_rs_put.svg)|[25_758](vec_rs_remove.svg)|[3_171_665](vec_rs_upgrade.svg)|

## Stable structures

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|btreemap_rs|471_597|76_392_040|2_490_368|[65_130](btreemap_rs_get.svg)|[97_326](btreemap_rs_put.svg)|[85_331](btreemap_rs_remove.svg)|[126_467_332](btreemap_rs_upgrade.svg)|
|btreemap_stable_rs|483_530|5_255_631_698|2_031_616|[3_167_240](btreemap_stable_rs_get.svg)|[5_784_534](btreemap_stable_rs_put.svg)|[9_888_430](btreemap_stable_rs_remove.svg)|[731_136](btreemap_stable_rs_upgrade.svg)|
|heap_rs|459_314|7_001_770|2_228_224|[50_072](heap_rs_get.svg)|[23_593](heap_rs_put.svg)|[50_044](heap_rs_remove.svg)|[26_819_689](heap_rs_upgrade.svg)|
|heap_stable_rs|444_563|319_633_532|458_752|[2_674_735](heap_stable_rs_get.svg)|[278_363](heap_stable_rs_put.svg)|[2_654_537](heap_stable_rs_remove.svg)|[731_285](heap_stable_rs_upgrade.svg)|
|vec_rs|453_413|3_079_434|2_228_224|[17_298](vec_rs_get.svg)|[18_473](vec_rs_put.svg)|[17_999](vec_rs_remove.svg)|[24_772_181](vec_rs_upgrade.svg)|
|vec_stable_rs|441_204|75_145_327|458_752|[71_671](vec_stable_rs_get.svg)|[91_519](vec_stable_rs_put.svg)|[94_915](vec_stable_rs_remove.svg)|[731_270](vec_stable_rs_upgrade.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.2 (source vy3jgjpa-6ywclfhp-r10kgfpz-gkw93wh8)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
