#!ic-repl
load "../prelude.sh";

let hashmap = wasm_profiling("motoko/.dfx/local/canisters/hashmap/hashmap.wasm");
let triemap = wasm_profiling("motoko/.dfx/local/canisters/triemap/triemap.wasm");
let rbtree = wasm_profiling("motoko/.dfx/local/canisters/rbtree/rbtree.wasm");
let splay = wasm_profiling("motoko/.dfx/local/canisters/splay/splay.wasm");
let btree = wasm_profiling("motoko/.dfx/local/canisters/btreemap/btreemap.wasm");
let zhenya = wasm_profiling("motoko/.dfx/local/canisters/zhenya_hashmap/zhenya_hashmap.wasm");
let heap = wasm_profiling("motoko/.dfx/local/canisters/heap/heap.wasm");
let hashmap_rs = wasm_profiling("rust/.dfx/local/canisters/hashmap/hashmap.wasm");
let btreemap_rs = wasm_profiling("rust/.dfx/local/canisters/btreemap/btreemap.wasm");
let heap_rs = wasm_profiling("rust/.dfx/local/canisters/heap/heap.wasm");
let imrc_hashmap_rs = wasm_profiling("rust/.dfx/local/canisters/imrc_hashmap/imrc_hashmap.wasm");
let movm_rs = wasm_profiling("rust/.dfx/local/canisters/movm/movm.wasm");
let movm_dynamic_rs = wasm_profiling("rust/.dfx/local/canisters/movm_dynamic/movm_dynamic.wasm");

let file = "README.md";
output(file, "\n## Map\n\n| |binary_size|generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|--:|\n");

function perf(wasm, title, init) {
  let cid = install(wasm, encode (), null);

  output(file, stringify("|", title, "|", wasm.size(), "|"));
  call cid.__toggle_tracing();
  call cid.generate(init);
  output(file, stringify(__cost__, "|"));
  call cid.get_mem();
  output(file, stringify(_[2], "|"));

  call cid.__toggle_tracing();
  call cid.batch_get(50);
  let svg = stringify(title, "_get.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".batch_get"), svg);

  call cid.batch_put(50);
  let svg = stringify(title, "_put.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".batch_put"), svg);
  call cid.get_mem();

  call cid.batch_remove(50);
  let svg = stringify(title, "_remove.svg");
  output(file, stringify("[", __cost__, "](",svg, ")|\n"));
  flamegraph(cid, stringify(title, ".batch_remove"), svg);
};

let init_size = 50000;
perf(hashmap, "hashmap", init_size);
perf(triemap, "triemap", init_size);
perf(rbtree, "rbtree", init_size);
perf(splay, "splay", init_size);
perf(btree, "btree", init_size);
perf(zhenya, "zhenya_hashmap", init_size);
perf(btreemap_rs, "btreemap_rs", init_size);
perf(hashmap_rs, "hashmap_rs", init_size);

output(file, "\n## Priority queue\n\n| |binary_size|heapify 50k|mem|pop_min 50|put 50|\n|--:|--:|--:|--:|--:|--:|\n");
perf(heap, "heap", init_size);
perf(heap_rs, "heap_rs", init_size);

let movm_size = 10000;
output(file, "\n## MoVM\n\n| |binary_size|generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|--:|\n");
perf(hashmap, "hashmap", movm_size);
perf(hashmap_rs, "hashmap_rs", movm_size);
perf(imrc_hashmap_rs, "imrc_hashmap_rs", movm_size);
perf(movm_rs, "movm_rs", movm_size);
perf(movm_dynamic_rs, "movm_dynamic_rs", movm_size);
