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

| |generate 800k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|
|default|[1_012_258_537](default_init.svg)|59_396_776|[50](default_get.svg)|[50](default_put.svg)|[50](default_remove.svg)|
|copying|[1_012_258_487](copying_init.svg)|59_396_776|[1_012_236_046](copying_get.svg)|[1_012_303_056](copying_put.svg)|[1_012_240_283](copying_remove.svg)|
|compacting|[1_675_009_925](compacting_init.svg)|59_396_776|[1_292_955_500](compacting_get.svg)|[1_532_273_641](compacting_put.svg)|[1_558_502_986](compacting_remove.svg)|
|generational|[2_498_146_508](generational_init.svg)|59_405_240|[977_578_983](generational_get.svg)|[1_044_991](generational_put.svg)|[960_405](generational_remove.svg)|
|incremental|[32_320_754](incremental_init.svg)|1_136_155_048|[290_257_785](incremental_get.svg)|[292_951_006](incremental_put.svg)|[292_977_552](incremental_remove.svg)|


## Actor class

| |binary size|put new bucket|put existing bucket|get|
|--|--:|--:|--:|--:|
|Map|261_606|[656_047](map_put.svg)|[4_459](map_put_existing.svg)|[4_919](map_get.svg)|
