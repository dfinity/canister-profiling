# Motoko Specific Benchmarks

Measure various features only available in Motoko.

* Garbage Collection. Measure Motoko garbage collection cost using the [Triemap benchmark](https://github.com/dfinity/canister-profiling/blob/main/collections/motoko/src/triemap.mo). The max mem column reports `rts_max_live_size` after `generate` call. The cycle cost numbers reported here are garbage collection cost only. Some flamegraphs are truncated due to the 2M log size limit.

  - default. Compile with the default GC option. With the current GC scheduler, `generate` will trigger the copying GC. The rest of the methods will not trigger GC.
  - copying. Compile with `--force-gc --copying-gc`.
  - compacting. Compile with `--force-gc --compacting-gc`.
  - generational. Compile with `--force-gc --generational-gc`.

* Actor class. Measure the cost of spawning actor class, using the [Actor classes example](https://github.com/dfinity/examples/tree/master/motoko/classes).




## Garbage Collection

| |generate 80k|max mem|batch_get 50|batch_put 50|batch_remove 50|
|--:|--:|--:|--:|--:|--:|
|default|[247_113_104](default_init.svg)|15_539_816|[50](default_get.svg)|[50](default_put.svg)|[50](default_remove.svg)|
|copying|[247_113_054](copying_init.svg)|15_539_816|[247_107_545](copying_get.svg)|[247_259_605](copying_put.svg)|[247_259_929](copying_remove.svg)|
|compacting|[409_359_701](compacting_init.svg)|15_539_816|[308_335_627](compacting_get.svg)|[348_771_032](compacting_put.svg)|[352_659_043](compacting_remove.svg)|
|generational|[624_416_969](generational_init.svg)|15_540_080|[57_019](generational_get.svg)|[1_390_400](generational_put.svg)|[1_060_223](generational_remove.svg)|


## Actor class

|binary size|put new bucket|put existing bucket|get|
|--:|--:|--:|--:|
|311_519|[795_028](map_put.svg)|[9_149](map_put_existing.svg)|[9_493](map_get.svg)|
