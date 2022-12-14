#!ic-repl
load "../prelude.sh";

let default = wasm_profiling("default.wasm");
let copying = wasm_profiling("copying.wasm");
let compacting = wasm_profiling("compacting.wasm");
let generational = wasm_profiling("generational.wasm");

let file = "README.md";
output(file, "\n| |generate 80k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|\n");

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

let init_size = 80000;
perf_mo(default, "default", init_size);
perf_mo(copying, "copying", init_size);
perf_mo(compacting, "compacting", init_size);
perf_mo(generational, "generational", init_size);
