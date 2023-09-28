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
|default|[886_041_847](default_init.svg)|51_991_332|[50](default_get.svg)|[50](default_put.svg)|[50](default_remove.svg)|
|copying|[886_041_797](copying_init.svg)|51_991_332|[886_022_172](copying_get.svg)|[886_091_260](copying_put.svg)|[886_024_340](copying_remove.svg)|
|compacting|[1_465_245_786](compacting_init.svg)|51_991_332|[1_131_731_112](compacting_get.svg)|[1_337_770_678](compacting_put.svg)|[1_364_176_157](compacting_remove.svg)|
|generational|[2_184_686_782](generational_init.svg)|51_999_796|[855_707_553](generational_get.svg)|[1_057_794](generational_put.svg)|[947_862](generational_remove.svg)|
|incremental|[28_518_613](incremental_init.svg)|985_885_592|[290_276_212](incremental_get.svg)|[292_998_697](incremental_put.svg)|[292_988_797](incremental_remove.svg)|


## Actor class

| |binary size|put new bucket|put existing bucket|get|
|--|--:|--:|--:|--:|
|Map|261_479|[654_501](map_put.svg)|[4_459](map_put_existing.svg)|[4_919](map_get.svg)|
