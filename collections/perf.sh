#!ic-repl
load "../prelude.sh";

let hashmap = install(wasm_profiling("motoko/.dfx/local/canisters/hashmap/hashmap.wasm"), encode (), null);
let triemap = install(wasm_profiling("motoko/.dfx/local/canisters/triemap/triemap.wasm"), encode (), null);
let rbtree = install(wasm_profiling("motoko/.dfx/local/canisters/rbtree/rbtree.wasm"), encode (), null);
let splay = install(wasm_profiling("motoko/.dfx/local/canisters/splay/splay.wasm"), encode (), null);
let hashmap_rs = install(wasm_profiling("rust/.dfx/local/canisters/hashmap/hashmap.wasm"), encode (), null);
let btreemap_rs = install(wasm_profiling("rust/.dfx/local/canisters/btreemap/btreemap.wasm"), encode (), null);

function perf(cid) {
  call cid.__toggle_tracing();
  call cid.generate(50000);
  let _ = get_memory(cid);
  call cid.__toggle_tracing();
  call cid.batch_get(50);
  call cid.batch_put(50);
  let _ = get_memory(cid);
  call cid.batch_remove(50);
};

perf(hashmap);
perf(triemap);
perf(rbtree);
perf(splay);
perf(hashmap_rs);
perf(btreemap_rs);
