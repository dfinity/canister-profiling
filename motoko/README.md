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
|default|[1_074_136_336](default_init.svg)|47_793_792|[119](default_get.svg)|[119](default_put.svg)|[119](default_remove.svg)|
|copying|[1_074_136_218](copying_init.svg)|47_793_792|[1_073_873_789](copying_get.svg)|[1_073_954_095](copying_put.svg)|[1_073_875_311](copying_remove.svg)|
|compacting|[1_554_238_605](compacting_init.svg)|47_793_792|[1_200_791_965](compacting_get.svg)|[1_424_078_246](compacting_put.svg)|[1_447_969_756](compacting_remove.svg)|
|generational|[2_326_734_591](generational_init.svg)|47_802_256|[899_105_682](generational_get.svg)|[1_214_812](generational_put.svg)|[1_107_099](generational_remove.svg)|
|incremental|[29_505_471](incremental_init.svg)|976_097_724|[469_026_873](incremental_get.svg)|[496_491_319](incremental_put.svg)|[1_282_778_770](incremental_remove.svg)|


## Actor class

| |binary size|put new bucket|put existing bucket|get|
|--|--:|--:|--:|--:|
|Map|420_662|[757_684](map_put.svg)|[16_349](map_put_existing.svg)|[16_917](map_get.svg)|

> ## Environment
> * dfx 0.24.0
> * Motoko compiler 0.13.0 (source dq4zmqc9-34xf70ip-6lrc3v7p-z1m6aq95)
> * rustc 1.81.0 (eeb90cda1 2024-09-04)
> * ic-repl 0.7.6
> * ic-wasm 0.9.0
