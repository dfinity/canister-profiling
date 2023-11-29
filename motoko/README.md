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
|default|[1_171_395_786](default_init.svg)|51_991_392|[119](default_get.svg)|[119](default_put.svg)|[119](default_remove.svg)|
|copying|[1_171_395_668](copying_init.svg)|51_991_392|[1_171_104_136](copying_get.svg)|[1_171_195_696](copying_put.svg)|[1_171_106_949](copying_remove.svg)|
|compacting|[1_672_114_659](compacting_init.svg)|51_991_392|[1_290_052_154](compacting_get.svg)|[1_533_417_828](compacting_put.svg)|[1_564_512_242](compacting_remove.svg)|
|generational|[2_529_073_372](generational_init.svg)|51_999_856|[999_515_201](generational_get.svg)|[1_232_740](generational_put.svg)|[1_103_853](generational_remove.svg)|
|incremental|[29_503_138](incremental_init.svg)|985_890_580|[333_755_986](incremental_get.svg)|[336_886_802](incremental_put.svg)|[336_875_628](incremental_remove.svg)|


## Actor class

| |binary size|put new bucket|put existing bucket|get|
|--|--:|--:|--:|--:|
|Map|299_052|[813_512](map_put.svg)|[16_099](map_put_existing.svg)|[16_644](map_get.svg)|

> ## Environment
> * dfx 0.15.2-beta.1
> * Motoko compiler 0.10.2 (source vy3jgjpa-6ywclfhp-r10kgfpz-gkw93wh8)
> * rustc 1.73.0 (cc66ad468 2023-10-03)
> * ic-repl 0.6.0
> * ic-wasm 0.7.0
