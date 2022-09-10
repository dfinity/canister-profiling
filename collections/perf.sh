#!ic-repl
load "../prelude.sh";

let hashmap = wasm_profiling("motoko/.dfx/local/canisters/hashmap/hashmap.wasm");
let triemap = wasm_profiling("motoko/.dfx/local/canisters/triemap/triemap.wasm");
let rbtree = wasm_profiling("motoko/.dfx/local/canisters/rbtree/rbtree.wasm");
let splay = wasm_profiling("motoko/.dfx/local/canisters/splay/splay.wasm");
let hashmap_rs = wasm_profiling("rust/.dfx/local/canisters/hashmap/hashmap.wasm");
let btreemap_rs = wasm_profiling("rust/.dfx/local/canisters/btreemap/btreemap.wasm");

let file = "README.md";
output(file, "| |generate|mem|batch_get|batch_put|batch_remove|\n|--:|--:|--:|--:|--:|--:|\n");

function perf_mo(wasm, title) {
  let cid = install(wasm, encode (), null);
  
  output(file, stringify("|", title, "|"));
  call cid.__toggle_tracing();
  call cid.generate(50000);
  output(file, stringify(__cost__, "|"));
  call cid.get_mem();
  output(file, stringify(_[2], "|"));
  
  call cid.__toggle_tracing();
  call cid.batch_get(50);
  output(file, stringify(__cost__, "|"));
  flamegraph(cid, stringify(title, ".batch_get"), stringify(title, "_get"));
  
  call cid.batch_put(50);
  output(file, stringify(__cost__, "|"));
  flamegraph(cid, stringify(title, ".batch_put"), stringify(title, "_put"));
  call cid.get_mem();
  
  call cid.batch_remove(50);
  output(file, stringify(__cost__, "|\n"));
  flamegraph(cid, stringify(title, ".batch_remove"), stringify(title, "_remove"));
};

function perf_rs(wasm, title) {
  let cid = install(wasm, encode (), null);

  output(file, stringify("|", title, "|"));
  call cid.__toggle_tracing();
  call cid.generate(50000);
  output(file, stringify(__cost__, "|"));
  let _ = get_memory(cid);
  output(file, stringify(_, "|"));
  
  call cid.__toggle_tracing();
  call cid.batch_get(50);
  output(file, stringify(__cost__, "|"));
  flamegraph(cid, stringify(title, ".batch_get"), stringify(title, "_get"));
  
  call cid.batch_put(50);
  output(file, stringify(__cost__, "|"));
  flamegraph(cid, stringify(title, ".batch_put"), stringify(title, "_put"));
  let _ = get_memory(cid);

  call cid.batch_remove(50);
  output(file, stringify(__cost__, "|\n"));
  flamegraph(cid, stringify(title, ".batch_remove"), stringify(title, "_remove"));
};

perf_mo(hashmap, "hashmap");
perf_mo(triemap, "triemap");
perf_mo(rbtree, "rbtree");
perf_mo(splay, "splay");
perf_rs(hashmap_rs, "hashmap_rs");
perf_rs(btreemap_rs, "btreemap_rs");

