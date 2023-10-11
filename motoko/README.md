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
|default|[886_042_039](default_init.svg)|51_991_392|[50](default_get.svg)|[50](default_put.svg)|[50](default_remove.svg)|
|copying|[886_041_989](copying_init.svg)|51_991_392|[886_022_376](copying_get.svg)|[886_091_464](copying_put.svg)|[886_024_532](copying_remove.svg)|
|compacting|[1_465_238_570](compacting_init.svg)|51_991_392|[1_131_731_091](compacting_get.svg)|[1_337_770_735](compacting_put.svg)|[1_364_176_230](compacting_remove.svg)|
|generational|[2_184_682_993](generational_init.svg)|51_999_856|[855_707_553](generational_get.svg)|[1_057_808](generational_put.svg)|[947_924](generational_remove.svg)|
|incremental|[28_518_613](incremental_init.svg)|985_885_652|[290_276_212](incremental_get.svg)|[292_998_697](incremental_put.svg)|[292_988_797](incremental_remove.svg)|


## Actor class

| |binary size|put new bucket|put existing bucket|get|
|--|--:|--:|--:|--:|
|Map|261_665|[654_501](map_put.svg)|[4_459](map_put_existing.svg)|[4_919](map_get.svg)|

> ## Environment
> * dfx 0.15.1
> * Motoko compiler 0.10.0 (source a3ywvw0a-p5a03qy6-vscbl9j8-qxszbxa6)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.5.1
> * ic-wasm 0.6.0
