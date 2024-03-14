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
|hashmap|189_929|8_184_618_025|56_000_256|[342_784](hashmap_get.svg)|[6_462_528_122](hashmap_put.svg)|[368_420](hashmap_remove.svg)|[10_728_193_099](hashmap_upgrade.svg)|
|triemap|195_472|13_661_315_924|68_228_576|[252_649](triemap_get.svg)|[657_794](triemap_put.svg)|[648_084](triemap_remove.svg)|[15_499_470_884](triemap_upgrade.svg)|
|rbtree|185_907|7_009_043_570|52_000_464|[116_348](rbtree_get.svg)|[318_320](rbtree_put.svg)|[330_226](rbtree_remove.svg)|[6_870_900_152](rbtree_upgrade.svg)|
|splay|190_457|13_157_617_583|48_000_400|[631_329](splay_get.svg)|[662_998](splay_put.svg)|[928_144](splay_remove.svg)|[4_308_925_798](splay_upgrade.svg)|
|btree|230_321|10_223_929_607|25_108_416|[357_912](btree_get.svg)|[485_794](btree_put.svg)|[539_490](btree_remove.svg)|[2_861_974_825](btree_upgrade.svg)|
|zhenya_hashmap|188_894|2_360_638_679|16_777_504|[58_204](zhenya_hashmap_get.svg)|[66_552](zhenya_hashmap_put.svg)|[79_675](zhenya_hashmap_remove.svg)|[3_018_208_083](zhenya_hashmap_upgrade.svg)|
|btreemap_rs|553_671|1_792_613_493|27_590_656|[75_414](btreemap_rs_get.svg)|[125_227](btreemap_rs_put.svg)|[86_761](btreemap_rs_remove.svg)|[3_204_184_669](btreemap_rs_upgrade.svg)|
|imrc_hashmap_rs|555_693|2_584_502_429|244_973_568|[38_020](imrc_hashmap_rs_get.svg)|[179_184](imrc_hashmap_rs_put.svg)|[116_050](imrc_hashmap_rs_remove.svg)|[6_262_892_389](imrc_hashmap_rs_upgrade.svg)|
|hashmap_rs|541_994|443_248_419|73_138_176|[21_565](hashmap_rs_get.svg)|[26_650](hashmap_rs_put.svg)|[24_961](hashmap_rs_remove.svg)|[1_565_649_003](hashmap_rs_upgrade.svg)|

## Priority queue

| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|heap|166_903|5_554_617_018|24_000_360|[621_690](heap_get.svg)|[227_224](heap_put.svg)|[592_588](heap_remove.svg)|[3_189_831_485](heap_upgrade.svg)|
|heap_rs|533_034|139_670_245|18_284_544|[57_437](heap_rs_get.svg)|[22_991](heap_rs_put.svg)|[57_485](heap_rs_remove.svg)|[648_953_257](heap_rs_upgrade.svg)|

## Growable array

| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|buffer|173_903|2_601_059|65_644|[95_506](buffer_get.svg)|[803_474](buffer_put.svg)|[173_506](buffer_remove.svg)|[3_091_310](buffer_upgrade.svg)|
|vector|171_932|1_952_689|24_580|[126_130](vector_get.svg)|[186_485](vector_put.svg)|[176_123](vector_remove.svg)|[4_675_192](vector_upgrade.svg)|
|vec_rs|533_368|289_403|1_376_256|[17_283](vec_rs_get.svg)|[30_525](vec_rs_put.svg)|[23_285](vec_rs_remove.svg)|[3_826_760](vec_rs_upgrade.svg)|

## Stable structures

| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|
|--:|--:|--:|--:|--:|--:|--:|--:|
|btreemap_rs|553_671|76_164_138|2_555_904|[64_972](btreemap_rs_get.svg)|[97_154](btreemap_rs_put.svg)|[85_766](btreemap_rs_remove.svg)|[139_625_748](btreemap_rs_upgrade.svg)|
|btreemap_stable_rs|555_424|4_564_073_317|2_031_616|[2_706_123](btreemap_stable_rs_get.svg)|[5_033_940](btreemap_stable_rs_put.svg)|[8_578_143](btreemap_stable_rs_remove.svg)|[729_341](btreemap_stable_rs_upgrade.svg)|
|heap_rs|533_034|7_052_097|2_293_760|[49_946](heap_rs_get.svg)|[23_239](heap_rs_put.svg)|[49_834](heap_rs_remove.svg)|[33_661_680](heap_rs_upgrade.svg)|
|heap_stable_rs|517_798|272_319_598|458_752|[2_306_666](heap_stable_rs_get.svg)|[239_309](heap_stable_rs_put.svg)|[2_289_588](heap_stable_rs_remove.svg)|[729_349](heap_stable_rs_upgrade.svg)|
|vec_rs|533_368|3_079_779|2_293_760|[17_283](vec_rs_get.svg)|[18_375](vec_rs_put.svg)|[17_673](vec_rs_remove.svg)|[31_322_355](vec_rs_upgrade.svg)|
|vec_stable_rs|515_280|63_345_046|458_752|[64_434](vec_stable_rs_get.svg)|[79_730](vec_stable_rs_put.svg)|[83_628](vec_stable_rs_remove.svg)|[729_352](vec_stable_rs_upgrade.svg)|

> ## Environment
> * dfx 0.18.0
> * Motoko compiler 0.11.0 (source lndfxrzc-zr7pf1k6-nr3nr3d7-jfla8nbn)
> * rustc 1.76.0 (07dca489a 2024-02-04)
> * ic-repl 0.7.0
> * ic-wasm 0.7.0
