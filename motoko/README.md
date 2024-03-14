# Motoko Specific Benchmarks

Measure various features only available in Motoko.

* Garbage Collection. Measure Motoko garbage collection cost using the [Triemap benchmark](https://github.com/dfinity/canister-profiling/blob/main/collections/motoko/src/triemap.mo). The max mem column reports `rts_max_heap_size` after `generate` call. The cycle cost numbers reported here are garbage collection cost only. Some flamegraphs are truncated due to the 2M log size limit. The `dfx`/`ic-wasm` optimizer is disabled for the garbage collection test cases due to how the optimizer affects function names, making profiling trickier.

  - default. Compile with the default GC option. With the current GC scheduler, `generate` will trigger the copying GC. The rest of the methods will not trigger GC.
  - copying. Compile with `--force-gc --copying-gc`.
  - compacting. Compile with `--force-gc --compacting-gc`.
  - generational. Compile with `--force-gc --generational-gc`.
  - incremental. Compile with `--force-gc --incremental-gc`.

* Actor class. Measure the cost of spawning actor class, using the [Actor classes example](https://github.com/dfinity/examples/tree/master/motoko/classes).




## Garbage Collection

| |generate 700k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|
|default|[1_068_192_695](default_init.svg)|47_793_792|[119](default_get.svg)|[119](default_put.svg)|[119](default_remove.svg)|
|copying|[1_068_192_577](copying_init.svg)|47_793_792|[1_067_924_316](copying_get.svg)|[1_068_004_203](copying_put.svg)|[1_067_925_853](copying_remove.svg)|
|compacting|[1_545_586_176](compacting_init.svg)|47_793_792|[1_192_139_528](compacting_get.svg)|[1_415_425_189](compacting_put.svg)|[1_439_317_325](compacting_remove.svg)|
|generational|[2_304_140_531](generational_init.svg)|47_802_256|[882_208_645](generational_get.svg)|[1_211_144](generational_put.svg)|[1_103_549](generational_remove.svg)|
|incremental|[29_503_170](incremental_init.svg)|976_097_188|[471_911_803](incremental_get.svg)|[497_465_467](incremental_put.svg)|[1_221_308_722](incremental_remove.svg)|


## Actor class

| |binary size|put new bucket|put existing bucket|get|
|--|--:|--:|--:|--:|
|Map|299_217|[813_521](map_put.svg)|[16_115](map_put_existing.svg)|[16_660](map_get.svg)|

> ## Environment
> * dfx 0.18.0
> * Motoko compiler 0.11.0 (source lndfxrzc-zr7pf1k6-nr3nr3d7-jfla8nbn)
> * rustc 1.76.0 (07dca489a 2024-02-04)
> * ic-repl 0.7.0
> * ic-wasm 0.7.0
