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
|hashmap|189_608|8_370_836_596|61_987_852|[344_911](hashmap_get.svg)|[6_593_214_552](hashmap_put.svg)|[371_223](hashmap_remove.svg)|[11_026_879_813](hashmap_upgrade.svg)|
|triemap|195_507|13_855_038_807|74_216_172|[254_589](triemap_get.svg)|[661_468](triemap_put.svg)|[650_820](triemap_remove.svg)|[15_817_661_582](triemap_upgrade.svg)|
|rbtree|186_562|7_127_318_517|57_996_060|[114_300](rbtree_get.svg)|[318_352](rbtree_put.svg)|[328_277](rbtree_remove.svg)|[7_169_325_607](rbtree_upgrade.svg)|
|splay|190_525|13_247_297_529|53_995_996|[628_661](splay_get.svg)|[661_579](splay_put.svg)|[921_933](splay_remove.svg)|[4_567_871_575](splay_upgrade.svg)|
|btree|229_870|10_266_014_811|31_104_012|[353_622](btree_get.svg)|[482_125](btree_put.svg)|[533_935](btree_remove.svg)|[3_134_168_915](btree_upgrade.svg)|
|zhenya_hashmap|189_285|2_570_554_540|22_773_100|[60_196](zhenya_hashmap_get.svg)|[70_137](zhenya_hashmap_put.svg)|[82_453](zhenya_hashmap_remove.svg)|[3_305_550_277](zhenya_hashmap_upgrade.svg)|
|btreemap_rs|537_393|1_793_333_047|27_590_656|[75_328](btreemap_rs_get.svg)|[125_166](btreemap_rs_put.svg)|[86_260](btreemap_rs_remove.svg)|[2_937_041_107](btreemap_rs_upgrade.svg)|
|imrc_hashmap_rs|542_882|2_584_501_850|244_973_568|[37_762](imrc_hashmap_rs_get.svg)|[178_926](imrc_hashmap_rs_put.svg)|[115_385](imrc_hashmap_rs_remove.svg)|[5_796_587_958](imrc_hashmap_rs_upgrade.svg)|
|hashmap_rs|529_458|439_248_112|73_138_176|[21_501](hashmap_rs_get.svg)|[26_711](hashmap_rs_put.svg)|[25_024](hashmap_rs_remove.svg)|[1_298_646_667](hashmap_rs_upgrade.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|heap|167_497|5_697_880_501|29_995_956|[621_338](heap_get.svg)|[228_674](heap_put.svg)|[592_198](heap_remove.svg)|[3_309_807_456](heap_upgrade.svg)|
|heap_rs|525_853|139_669_830|18_284_544|[57_419](heap_rs_get.svg)|[23_051](heap_rs_put.svg)|[57_545](heap_rs_remove.svg)|[510_960_192](heap_rs_upgrade.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|buffer|173_906|2_570_947|65_644|[95_490](buffer_get.svg)|[800_452](buffer_put.svg)|[170_490](buffer_remove.svg)|[3_061_307](buffer_upgrade.svg)|
|vector|172_249|1_920_997|24_580|[126_114](vector_get.svg)|[183_385](vector_put.svg)|[175_981](vector_remove.svg)|[4_695_522](vector_upgrade.svg)|
|vec_rs|520_881|289_040|1_376_256|[17_251](vec_rs_get.svg)|[30_571](vec_rs_put.svg)|[23_331](vec_rs_remove.svg)|[3_161_017](vec_rs_upgrade.svg)|

## Stable structures

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|btreemap_rs|537_393|76_200_333|2_555_904|[64_886](btreemap_rs_get.svg)|[97_044](btreemap_rs_put.svg)|[85_272](btreemap_rs_remove.svg)|[126_265_270](btreemap_rs_upgrade.svg)|
|btreemap_stable_rs|543_609|4_561_985_735|2_031_616|[2_707_064](btreemap_stable_rs_get.svg)|[5_026_642](btreemap_stable_rs_put.svg)|[8_594_683](btreemap_stable_rs_remove.svg)|[729_311](btreemap_stable_rs_upgrade.svg)|
|heap_rs|525_853|7_051_730|2_293_760|[49_928](heap_rs_get.svg)|[23_299](heap_rs_put.svg)|[49_894](heap_rs_remove.svg)|[26_768_703](heap_rs_upgrade.svg)|
|heap_stable_rs|506_559|271_553_517|458_752|[2_294_851](heap_stable_rs_get.svg)|[238_596](heap_stable_rs_put.svg)|[2_277_771](heap_stable_rs_remove.svg)|[729_317](heap_stable_rs_upgrade.svg)|
|vec_rs|520_881|3_079_382|2_293_760|[17_251](vec_rs_get.svg)|[18_421](vec_rs_put.svg)|[17_719](vec_rs_remove.svg)|[24_671_551](vec_rs_upgrade.svg)|
|vec_stable_rs|503_829|63_394_912|458_752|[62_491](vec_stable_rs_get.svg)|[79_685](vec_stable_rs_put.svg)|[81_633](vec_stable_rs_remove.svg)|[729_320](vec_stable_rs_upgrade.svg)|

> ## Environment
> * dfx 0.16.1
> * Motoko compiler 0.10.4 (source js20w7g2-ysgfrqd0-1cmy11nb-3wdy9y1k)
> * rustc 1.75.0 (82e1608df 2023-12-21)
> * ic-repl 0.6.2
> * ic-wasm 0.7.0
