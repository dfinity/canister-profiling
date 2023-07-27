#!ic-repl
load "../prelude.sh";

let sha_mo = wasm_profiling("motoko/.dfx/local/canisters/sha/sha.wasm");
let sha_rs = wasm_profiling("rust/.dfx/local/canisters/sha/sha.wasm");
let map_mo = wasm_profiling("motoko/.dfx/local/canisters/certified_map/certified_map.wasm");
let map_rs = wasm_profiling("rust/.dfx/local/canisters/certified_map/certified_map.wasm");
let sample = file("sample_wasm.bin");

let file = "README.md";
output(file, "\n## SHA-2\n\n| |binary_size|Sha256|Sha512|account_id|neuron_id|\n|--:|--:|--:|--:|--:|--:|\n");

function perf_sha(wasm, title) {
  let cid = install(wasm, encode (), null);

  output(file, stringify("|", title, "|", wasm.size(), "|"));
  call cid.sha256(sample);
  let svg = stringify(title, "_sha256.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".sha256"), svg);
  
  call cid.sha512(sample);
  let svg = stringify(title, "_sha512.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".sha512"), svg);

  let id = principal "rjstn-nz3de-deedb-beeff-eefff-fffff-fa";
  call cid.principalToAccount(id);
  let svg = stringify(title, "_to_account.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".principalToAccount"), svg);

  call cid.principalToNeuron(id, 42);
  let svg = stringify(title, "_to_neuron.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".principalToNeuron"), svg);
  
  output(file, "\n");
  uninstall(cid);
};
function perf_map(wasm, title) {
  let cid = install(wasm, encode (), null);
  output(file, stringify("|", title, "|", wasm.size(), "|"));
  call cid.inc();
  call cid.inc();
  let svg = stringify(title, "_inc.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".inc()"), svg);

  call cid.witness();
  let svg = stringify(title, "_witness.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".witness()"), svg);

  output(file, "\n");
  uninstall(cid);
};

perf_sha(sha_mo, "Motoko");
perf_sha(sha_rs, "Rust");

output(file, "\n## Certified map\n\n| |binary_size|inc|witness|\n|--:|--:|--:|--:|\n");
perf_map(map_mo, "Motoko");
perf_map(map_rs, "Rust");
