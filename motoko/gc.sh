#!ic-repl
load "../prelude.sh";

let default = wasm_profiling("default.wasm", vec{"schedule_copying_gc"});
let copying = wasm_profiling("copying.wasm", vec {"copying_gc"});
let compacting = wasm_profiling("compacting.wasm", vec{"compacting_gc"});
let generational = wasm_profiling("generational.wasm", vec{"generational_gc"});
let incremental = wasm_profiling("incremental.wasm", vec{"incremental_gc"});

let file = "README.md";
output(file, "\n\n## Garbage Collection\n\n| |generate 80k|max mem|batch_get 50|batch_put 50|batch_remove 50|\n|--:|--:|--:|--:|--:|--:|\n");

function perf_mo(wasm, title, init) {
  let cid = install(wasm, encode (), null);
  
  output(file, stringify("|", title, "|"));
  call cid.generate(init);
  let svg = stringify(title, "_init.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".generate"), svg);
  call cid.get_mem();
  output(file, stringify(_[2], "|"));
  
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
perf_mo(incremental, "incremental", init_size);
