# Motoko Garbage Collection

Measure Motoko garbage collection cost using the [RBTree benchmark](https://github.com/dfinity/canister-profiling/blob/main/collections/motoko/src/rbtree.mo). The max mem column reports `rts_max_live_size` after `generate` call.

* default. Compile with the default GC option. With the current GC scheduler, `generate` will trigger the copying GC. The rest of the methods will not trigger GC.
* copying. Compile with `--force-gc --copying-gc`.
* compacting. Compile with `--force-gc --compacting-gc`.
* generational. Compile with `--force-gc --generational-gc`.

