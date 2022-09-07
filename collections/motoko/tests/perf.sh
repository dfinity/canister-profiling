#!ic-repl
load "prelude.sh";

let hashmap = install(wasm_profiling("../.dfx/local/canisters/hashmap/hashmap.wasm"), null, null);
let triemap = install(wasm_profiling("../.dfx/local/canisters/triemap/triemap.wasm"), null, null);
let rbtree = install(wasm_profiling("../.dfx/local/canisters/rbtree/rbtree.wasm"), null, null);
let splay = install(wasm_profiling("../.dfx/local/canisters/splay/splay.wasm"), null, null);

call hashmap.__toggle_tracing();
call triemap.__toggle_tracing();
call rbtree.__toggle_tracing();
call splay.__toggle_tracing();
call hashmap.generate(50000);
let _ = get_memory(hashmap);
call triemap.generate(50000);
let _ = get_memory(triemap);
call rbtree.generate(50000);
let _ = get_memory(rbtree);
call splay.generate(50000);
let _ = get_memory(splay);

call hashmap.__toggle_tracing();
call triemap.__toggle_tracing();
call rbtree.__toggle_tracing();
call splay.__toggle_tracing();
call hashmap.batch_get(50);
call triemap.batch_get(50);
call rbtree.batch_get(50);
call splay.batch_get(50);

call hashmap.batch_put(50);
let _ = get_memory(hashmap);
call triemap.batch_put(50);
let _ = get_memory(triemap);
call rbtree.batch_put(50);
let _ = get_memory(rbtree);
call splay.batch_put(50);
let _ = get_memory(splay);

call hashmap.batch_remove(50);
call triemap.batch_remove(50);
call rbtree.batch_remove(50);
call splay.batch_remove(50);

