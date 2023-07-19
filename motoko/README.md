# Motoko Specific Benchmarks

Measure various features only available in Motoko.

* Garbage Collection. Measure Motoko garbage collection cost using the [Triemap benchmark](https://github.com/dfinity/canister-profiling/blob/main/collections/motoko/src/triemap.mo). The max mem column reports `rts_max_live_size` after `generate` call. The cycle cost numbers reported here are garbage collection cost only. Some flamegraphs are truncated due to the 2M log size limit. The `dfx`/`ic-wasm` optimizer is disabled for the garbage collection test cases due to how the optimizer affects function names, making profiling trickier.  

  - default. Compile with the default GC option. With the current GC scheduler, `generate` will trigger the copying GC. The rest of the methods will not trigger GC.
  - copying. Compile with `--force-gc --copying-gc`.
  - compacting. Compile with `--force-gc --compacting-gc`.
  - generational. Compile with `--force-gc --generational-gc`.

* Actor class. Measure the cost of spawning actor class, using the [Actor classes example](https://github.com/dfinity/examples/tree/master/motoko/classes).




## Garbage Collection

| |generate 80k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|
|default|[251_928_001](default_init.svg)|15_539_816|[50](default_get.svg)|[50](default_put.svg)|[50](default_remove.svg)|
|copying|[251_927_951](copying_init.svg)|15_539_816|[251_922_212](copying_get.svg)|[252_077_283](copying_put.svg)|[252_077_615](copying_remove.svg)|
|compacting|[385_346_090](compacting_init.svg)|15_539_816|[295_775_337](compacting_get.svg)|[354_723_987](compacting_put.svg)|[339_091_086](compacting_remove.svg)|
|generational|[590_168_177](generational_init.svg)|15_540_080|[51_200](generational_get.svg)|[1_051_273](generational_put.svg)|[594_436](generational_remove.svg)|
|incremental|[192_660_140](incremental_init.svg)|4_628|[519_293_666](incremental_get.svg)|[129_819_032](incremental_put.svg)|[321_970_457](incremental_remove.svg)|


## Actor class

| |binary size|put new bucket|put existing bucket|get|
|--|--:|--:|--:|--:|
|Map|254_076|[638_613](map_put.svg)|[4_449](map_put_existing.svg)|[4_909](map_get.svg)|
