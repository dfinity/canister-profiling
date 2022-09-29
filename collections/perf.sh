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

let file = "README.md";
output(file, "\n# Collection libraries\n\n| |generate 1k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|\n");

function perf_mo(wasm, title) {
  let cid = install(wasm, encode (), null);
  
  output(file, stringify("|", title, "|"));
  call cid.__toggle_tracing();
  call cid.generate(1000);
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

function perf_rs(wasm, title) {
  let cid = install(wasm, encode (), null);

  output(file, stringify("|", title, "|"));
  call cid.__toggle_tracing();
  call cid.generate(1000);
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

perf_mo(hashmap, "hashmap");
perf_mo(triemap, "triemap");
perf_mo(rbtree, "rbtree");
perf_mo(splay, "splay");
perf_rs(btreemap_rs, "btreemap_rs");
perf_rs(hashmap_rs, "hashmap_rs");
perf_rs(imrc_hashmap_rs, "imrc_hashmap_rs");
perf_rs(movm_rs, "movm_rs");

output(file, "\n## Priority queue\n\n| |heapify 50k|mem|pop_min|put|\n|--:|--:|--:|--:|--:|\n");
perf_mo(heap, "heap");
perf_rs(heap_rs, "heap_rs");
