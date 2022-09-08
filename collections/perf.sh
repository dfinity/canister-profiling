#!ic-repl
load "../prelude.sh";

let hashmap = install(wasm_profiling("motoko/.dfx/local/canisters/hashmap/hashmap.wasm"), encode (), null);
let triemap = install(wasm_profiling("motoko/.dfx/local/canisters/triemap/triemap.wasm"), encode (), null);
let rbtree = install(wasm_profiling("motoko/.dfx/local/canisters/rbtree/rbtree.wasm"), encode (), null);
let splay = install(wasm_profiling("motoko/.dfx/local/canisters/splay/splay.wasm"), encode (), null);
let hashmap_rs = install(wasm_profiling("rust/.dfx/local/canisters/hashmap/hashmap.wasm"), encode (), null);
let btreemap_rs = install(wasm_profiling("rust/.dfx/local/canisters/btreemap/btreemap.wasm"), encode (), null);

function perf_mo(cid) {
  call cid.__toggle_tracing();
  call cid.generate(50000);
  call cid.get_mem();
  call cid.__toggle_tracing();
  call cid.batch_get(50);
  call cid.batch_put(50);
  call cid.get_mem();
  call cid.batch_remove(50);
};

function perf_rs(cid) {
  call cid.__toggle_tracing();
  call cid.generate(50000);
  let _ = get_memory(cid);
  call cid.__toggle_tracing();
  call cid.batch_get(50);
  call cid.batch_put(50);
  let _ = get_memory(cid);
  call cid.batch_remove(50);
};

perf_mo(hashmap);
perf_mo(triemap);
perf_mo(rbtree);
perf_mo(splay);
perf_rs(hashmap_rs);
perf_rs(btreemap_rs);
