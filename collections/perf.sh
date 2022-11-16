#!ic-repl
load "../prelude.sh";

let hashmap = wasm_profiling("motoko/.dfx/local/canisters/hashmap/hashmap.wasm");
let triemap = wasm_profiling("motoko/.dfx/local/canisters/triemap/triemap.wasm");
let rbtree = wasm_profiling("motoko/.dfx/local/canisters/rbtree/rbtree.wasm");
let splay = wasm_profiling("motoko/.dfx/local/canisters/splay/splay.wasm");
let heap = wasm_profiling("motoko/.dfx/local/canisters/heap/heap.wasm");
let hashmap_rs = wasm_profiling("rust/.dfx/local/canisters/hashmap/hashmap.wasm");
let btreemap_rs = wasm_profiling("rust/.dfx/local/canisters/btreemap/btreemap.wasm");
let heap_rs = wasm_profiling("rust/.dfx/local/canisters/heap/heap.wasm");
let imrc_hashmap_rs = wasm_profiling("rust/.dfx/local/canisters/imrc_hashmap/imrc_hashmap.wasm");
let movm_rs = wasm_profiling("rust/.dfx/local/canisters/movm/movm.wasm");
let movm_dynamic_rs = wasm_profiling("rust/.dfx/local/canisters/movm_dynamic/movm_dynamic.wasm");

let file = "README.md";
output(file, "\n# Collection libraries\n\n| |generate 50k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|\n");

function perf_mo(wasm, title, init) {
  let cid = install(wasm, encode (), null);
  
  output(file, stringify("|", title, "|"));
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

function perf_rs(wasm, title, init) {
  let cid = install(wasm, encode (), null);

  output(file, stringify("|", title, "|"));
  call cid.__toggle_tracing();
  call cid.generate(init);
  output(file, stringify(__cost__, "|"));
  let _ = get_memory(cid);
  output(file, stringify(_, "|"));
  
  call cid.__toggle_tracing();
  call cid.batch_get(50);
  let svg = stringify(title, "_get.svg");  
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".batch_get"), svg);
  
  call cid.batch_put(50);
  let svg = stringify(title, "_put.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".batch_put"), svg);
  let _ = get_memory(cid);

  call cid.batch_remove(50);
  let svg = stringify(title, "_remove.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|\n"));
  flamegraph(cid, stringify(title, ".batch_remove"), svg);
};

let init_size = 50000;
perf_mo(hashmap, "hashmap", init_size);
perf_mo(triemap, "triemap", init_size);
perf_mo(rbtree, "rbtree", init_size);
perf_mo(splay, "splay", init_size);
perf_rs(btreemap_rs, "btreemap_rs", init_size);
perf_rs(hashmap_rs, "hashmap_rs", init_size);

output(file, "\n## Priority queue\n\n| |heapify 50k|mem|pop_min 50|put 50|\n|--:|--:|--:|--:|--:|\n");
perf_mo(heap, "heap", init_size);
perf_rs(heap_rs, "heap_rs", init_size);

let movm_size = 10000;
output(file, "\n## MoVM\n\n| |generate 10k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|\n");
perf_mo(hashmap, "hashmap", movm_size);
perf_rs(hashmap_rs, "hashmap_rs", movm_size);
perf_rs(imrc_hashmap_rs, "imrc_hashmap_rs", movm_size);
perf_rs(movm_rs, "movm_rs", movm_size);
perf_rs(movm_dynamic_rs, "movm_dynamic_rs", movm_size);
