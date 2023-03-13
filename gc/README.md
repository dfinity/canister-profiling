# Motoko Garbage Collection

Measure Motoko garbage collection cost using the [Triemap benchmark](https://github.com/dfinity/canister-profiling/blob/main/collections/motoko/src/triemap.mo). The max mem column reports `rts_max_live_size` after `generate` call. The cycle cost numbers reported here are garbage collection cost only. Some flamegraphs are truncated due to the 2M log size limit.

* default. Compile with the default GC option. With the current GC scheduler, `generate` will trigger the copying GC. The rest of the methods will not trigger GC.
* copying. Compile with `--force-gc --copying-gc`.
* compacting. Compile with `--force-gc --compacting-gc`.
* generational. Compile with `--force-gc --generational-gc`.

