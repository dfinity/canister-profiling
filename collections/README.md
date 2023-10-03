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
|hashmap|160_033|6_984_044_834|61_987_792|[288_670](hashmap_get.svg)|[5_536_856_465](hashmap_put.svg)|[310_195](hashmap_remove.svg)|[9_128_777_557](hashmap_upgrade.svg)|
|triemap|163_286|11_463_656_817|74_216_112|[222_926](triemap_get.svg)|[549_435](triemap_put.svg)|[540_205](triemap_remove.svg)|[13_075_150_332](triemap_upgrade.svg)|
|rbtree|157_961|5_979_230_865|57_996_000|[88_905](rbtree_get.svg)|[268_573](rbtree_put.svg)|[278_339](rbtree_remove.svg)|[5_771_873_746](rbtree_upgrade.svg)|
|splay|159_768|11_568_250_977|53_995_936|[552_014](splay_get.svg)|[581_765](splay_put.svg)|[810_321](splay_remove.svg)|[3_722_468_031](splay_upgrade.svg)|
|btree|187_709|8_224_242_624|31_103_952|[277_542](btree_get.svg)|[384_171](btree_put.svg)|[429_041](btree_remove.svg)|[2_517_935_226](btree_upgrade.svg)|
|zhenya_hashmap|160_321|2_201_622_488|22_773_040|[48_627](zhenya_hashmap_get.svg)|[61_839](zhenya_hashmap_put.svg)|[70_872](zhenya_hashmap_remove.svg)|[2_695_441_915](zhenya_hashmap_upgrade.svg)|
|btreemap_rs|494_261|1_654_113_949|27_590_656|[66_889](btreemap_rs_get.svg)|[112_603](btreemap_rs_put.svg)|[81_249](btreemap_rs_remove.svg)|[2_401_229_430](btreemap_rs_upgrade.svg)|
|imrc_hashmap_rs|500_199|2_407_082_660|244_973_568|[32_962](imrc_hashmap_rs_get.svg)|[163_913](imrc_hashmap_rs_put.svg)|[98_591](imrc_hashmap_rs_remove.svg)|[5_209_975_418](imrc_hashmap_rs_upgrade.svg)|
|hashmap_rs|487_986|403_296_624|73_138_176|[17_350](hashmap_rs_get.svg)|[21_647](hashmap_rs_put.svg)|[20_615](hashmap_rs_remove.svg)|[957_579_445](hashmap_rs_upgrade.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|heap|147_450|4_684_518_110|29_995_896|[511_505](heap_get.svg)|[186_471](heap_put.svg)|[487_212](heap_remove.svg)|[2_655_603_064](heap_upgrade.svg)|
|heap_rs|481_753|123_102_208|18_284_544|[53_480](heap_rs_get.svg)|[18_264](heap_rs_put.svg)|[53_621](heap_rs_remove.svg)|[349_011_816](heap_rs_upgrade.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|buffer|150_816|2_082_623|65_584|[73_092](buffer_get.svg)|[671_517](buffer_put.svg)|[127_592](buffer_remove.svg)|[2_468_118](buffer_upgrade.svg)|
|vector|152_363|1_588_260|24_520|[105_191](vector_get.svg)|[149_932](vector_put.svg)|[148_094](vector_remove.svg)|[3_837_918](vector_upgrade.svg)|
|vec_rs|480_829|265_643|1_376_256|[12_986](vec_rs_get.svg)|[25_331](vec_rs_put.svg)|[21_215](vec_rs_remove.svg)|[2_854_587](vec_rs_upgrade.svg)|

## Stable structures

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|btreemap_rs|494_261|70_231_886|2_555_904|[57_208](btreemap_rs_get.svg)|[86_708](btreemap_rs_put.svg)|[79_740](btreemap_rs_remove.svg)|[100_477_350](btreemap_rs_upgrade.svg)|
|btreemap_stable_rs|498_479|3_676_196_177|2_621_440|[2_190_807](btreemap_stable_rs_get.svg)|[4_013_463](btreemap_stable_rs_put.svg)|[6_777_299](btreemap_stable_rs_remove.svg)|[714_487](btreemap_stable_rs_upgrade.svg)|
|heap_rs|481_753|6_214_821|2_293_760|[45_761](heap_rs_get.svg)|[18_496](heap_rs_put.svg)|[45_732](heap_rs_remove.svg)|[18_367_724](heap_rs_upgrade.svg)|
|heap_stable_rs|469_772|240_377_401|458_752|[2_038_566](heap_stable_rs_get.svg)|[209_047](heap_stable_rs_put.svg)|[2_023_426](heap_stable_rs_remove.svg)|[714_446](heap_stable_rs_upgrade.svg)|
|vec_rs|480_829|2_866_842|2_293_760|[12_986](vec_rs_get.svg)|[14_081](vec_rs_put.svg)|[13_678](vec_rs_remove.svg)|[16_575_110](vec_rs_upgrade.svg)|
|vec_stable_rs|465_410|55_585_887|458_752|[52_650](vec_stable_rs_get.svg)|[67_745](vec_stable_rs_put.svg)|[69_641](vec_stable_rs_remove.svg)|[714_440](vec_stable_rs_upgrade.svg)|
