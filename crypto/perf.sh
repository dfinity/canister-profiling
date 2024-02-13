#!ic-repl
load "../prelude.sh";

let sha_mo = wasm_profiling("motoko/.dfx/local/canisters/sha/sha.wasm");
let sha_rs = wasm_profiling("rust/.dfx/local/canisters/sha/sha.wasm");
let map_mo = wasm_profiling("motoko/.dfx/local/canisters/certified_map/certified_map.wasm", mo_config);
let map_rs = wasm_profiling("rust/.dfx/local/canisters/certified_map/certified_map.wasm", rs_config);
let sample = file("sample_wasm.bin");

let file = "README.md";
output(file, "\n## SHA-2\n\n| |binary_size|SHA-256|SHA-512|account_id|neuron_id|\n|--:|--:|--:|--:|--:|--:|\n");

function perf_sha(wasm, title) {
  let cid = install(wasm, encode (), null);

  output(file, stringify("|", title, "|", wasm.size(), "|"));
  let sha256 = call cid.sha256(sample);
  let svg = stringify(title, "_sha256.svg");
  output(file, stringify("[", __cost_sha256, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".sha256"), svg);
  
  let sha512 = call cid.sha512(sample);
  let svg = stringify(title, "_sha512.svg");
  output(file, stringify("[", __cost_sha512, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".sha512"), svg);

  let id = principal "rjstn-nz3de-deedb-beeff-eefff-fffff-fa";
  let account = call cid.principalToAccount(id);
  let svg = stringify(title, "_to_account.svg");
  output(file, stringify("[", __cost_account, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".principalToAccount"), svg);

  let neuron = call cid.principalToNeuron(id, 42);
  let svg = stringify(title, "_to_neuron.svg");
  output(file, stringify("[", __cost_neuron, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".principalToNeuron"), svg);
  
  output(file, "\n");
  uninstall(cid);
  vec {sha256; sha512; account; neuron};
};
function perf_map(wasm, title, init_size) {
  let cid = install(wasm, encode (), null);
  output(file, stringify("|", title, "|", wasm.size(), "|"));
  call cid.__toggle_tracing();
  call cid.generate(init_size);
  output(file, stringify(__cost__, "|"));
  call cid.get_mem();
  output(file, stringify(_[1], "|"));

  call cid.__toggle_tracing();
  call cid.inc();
  let svg = stringify(title, "_inc.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".inc()"), svg);

  let witness = call cid.witness();
  let svg = stringify(title, "_witness.svg");
  output(file, stringify("[", __cost_witness, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".witness()"), svg);

  upgrade(cid, wasm, encode ());
  let svg = stringify(title, "_upgrade.svg");
  flamegraph(cid, stringify(title, ".upgrade"), svg);
  output(file, stringify("[", _, "](", svg, ")|"));
  
  output(file, "\n");
  uninstall(cid);
  witness;
};

let res1 = perf_sha(sha_mo, "Motoko");
let res2 = perf_sha(sha_rs, "Rust");
assert res1 == res2;

output(file, "\n## Certified map\n\n| |binary_size|generate 10k|max mem|inc|witness|upgrade|\n|--:|--:|--:|--:|--:|--:|--:|\n");
let init_size = 10_000;
let res1 = perf_map(map_mo, "Motoko", init_size);
let res2 = perf_map(map_rs, "Rust", init_size);
// Cannot check for equality because witness is not unique
// assert res1 == res2;
