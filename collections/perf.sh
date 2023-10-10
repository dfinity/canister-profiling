#!ic-repl
load "../prelude.sh";

let mo_config = record { start_page = 16; page_limit = 1024 };
let hashmap = wasm_profiling("motoko/.dfx/local/canisters/hashmap/hashmap.wasm", mo_config);
let triemap = wasm_profiling("motoko/.dfx/local/canisters/triemap/triemap.wasm", mo_config);
//let rbtree = wasm_profiling("motoko/.dfx/local/canisters/rbtree/rbtree.wasm", mo_config);
let splay = wasm_profiling("motoko/.dfx/local/canisters/splay/splay.wasm", mo_config);
let btree = wasm_profiling("motoko/.dfx/local/canisters/btreemap/btreemap.wasm", mo_config);
let zhenya = wasm_profiling("motoko/.dfx/local/canisters/zhenya_hashmap/zhenya_hashmap.wasm", mo_config);
let heap = wasm_profiling("motoko/.dfx/local/canisters/heap/heap.wasm", mo_config);
let buffer = wasm_profiling("motoko/.dfx/local/canisters/buffer/buffer.wasm", mo_config);
let vector = wasm_profiling("motoko/.dfx/local/canisters/vector/vector.wasm", mo_config);

let rs_config = record { start_page = 1; page_limit = 1024 };
let hashmap_rs = wasm_profiling("rust/.dfx/local/canisters/hashmap/hashmap.wasm", rs_config);
let btreemap_rs = wasm_profiling("rust/.dfx/local/canisters/btreemap/btreemap.wasm", rs_config);
let btreemap_stable_rs = wasm_profiling("rust/.dfx/local/canisters/btreemap_stable/btreemap_stable.wasm", rs_config);
let heap_rs = wasm_profiling("rust/.dfx/local/canisters/heap/heap.wasm", rs_config);
let heap_stable_rs = wasm_profiling("rust/.dfx/local/canisters/heap_stable/heap_stable.wasm", rs_config);
let imrc_hashmap_rs = wasm_profiling("rust/.dfx/local/canisters/imrc_hashmap/imrc_hashmap.wasm", rs_config);
let vector_rs = wasm_profiling("rust/.dfx/local/canisters/vector/vector.wasm", rs_config);
let vector_stable_rs = wasm_profiling("rust/.dfx/local/canisters/vector_stable/vector_stable.wasm", rs_config);

//let movm_rs = wasm_profiling("rust/.dfx/local/canisters/movm/movm.wasm");
//let movm_dynamic_rs = wasm_profiling("rust/.dfx/local/canisters/movm_dynamic/movm_dynamic.wasm");

let file = "README.md";

function perf(wasm, title, init, batch) {
  let cid = install(wasm, encode (), null);

  output(file, stringify("|", title, "|", wasm.size(), "|"));
  call cid.__toggle_tracing();
  call cid.generate(init);
  output(file, stringify(__cost__, "|"));
  call cid.get_mem();
  output(file, stringify(_[1], "|")); // use max_heap

  call cid.__toggle_tracing();
  call cid.batch_get(batch);
  let svg = stringify(title, "_get.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".batch_get"), svg);

  call cid.batch_put(batch);
  let svg = stringify(title, "_put.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".batch_put"), svg);
  call cid.get_mem();

  call cid.batch_remove(batch);
  let svg = stringify(title, "_remove.svg");
  output(file, stringify("[", __cost__, "](",svg, ")|"));
  flamegraph(cid, stringify(title, ".batch_remove"), svg);

  upgrade(cid, wasm, encode ());
  let svg = stringify(title, "_upgrade.svg");
  flamegraph(cid, stringify(title, ".upgrade"), svg);
  output(file, stringify("[", _, "](", svg, ")|\n"));

  uninstall(cid);
};

let init_size = 1_000_000;
let batch_size = 50;
output(file, "\n## Map\n\n| |binary_size|generate 1m|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|\n|--:|--:|--:|--:|--:|--:|--:|--:|\n");
perf(hashmap, "hashmap", init_size, batch_size);
perf(triemap, "triemap", init_size, batch_size);
//perf(rbtree, "rbtree", init_size, batch_size);
perf(splay, "splay", init_size, batch_size);
perf(btree, "btree", init_size, batch_size);
perf(zhenya, "zhenya_hashmap", init_size, batch_size);
perf(btreemap_rs, "btreemap_rs", init_size, batch_size);
perf(imrc_hashmap_rs, "imrc_hashmap_rs", init_size, batch_size);
perf(hashmap_rs, "hashmap_rs", init_size, batch_size);

output(file, "\n## Priority queue\n\n| |binary_size|heapify 1m|max mem|pop_min 50|put 50|pop_min 50|upgrade|\n|--:|--:|--:|--:|--:|--:|--:|--:|\n");
perf(heap, "heap", init_size, batch_size);
perf(heap_rs, "heap_rs", init_size, batch_size);

let init_size = 5_000;
let batch_size = 500;
output(file, "\n## Growable array\n\n| |binary_size|generate 5k|max mem|batch_get 500|batch_put 500|batch_remove 500|upgrade|\n|--:|--:|--:|--:|--:|--:|--:|--:|\n");
perf(buffer, "buffer", init_size, batch_size);
perf(vector, "vector", init_size, batch_size);
perf(vector_rs, "vec_rs", init_size, batch_size);

let init_size = 50_000;
let batch_size = 50;
output(file, "\n## Stable structures\n\n| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|upgrade|\n|--:|--:|--:|--:|--:|--:|--:|--:|\n");
perf(btreemap_rs, "btreemap_rs", init_size, batch_size);
perf(btreemap_stable_rs, "btreemap_stable_rs", init_size, batch_size);
perf(heap_rs, "heap_rs", init_size, batch_size);
perf(heap_stable_rs, "heap_stable_rs", init_size, batch_size);
perf(vector_rs, "vec_rs", init_size, batch_size);
perf(vector_stable_rs, "vec_stable_rs", init_size, batch_size);

/*
let movm_size = 10000;
output(file, "\n## MoVM\n\n| |binary_size|generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|--:|\n");
perf(hashmap, "hashmap", movm_size);
perf(hashmap_rs, "hashmap_rs", movm_size);
perf(imrc_hashmap_rs, "imrc_hashmap_rs", movm_size);
perf(movm_rs, "movm_rs", movm_size);
perf(movm_dynamic_rs, "movm_dynamic_rs", movm_size);
*/
