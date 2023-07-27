#!ic-repl
load "../prelude.sh";

let sha_mo = wasm_profiling("motoko/.dfx/local/canisters/sha/sha.wasm");
let sha_rs = wasm_profiling("rust/.dfx/local/canisters/sha/sha.wasm");
let sample = file("sample.wasm");

let file = "README.md";
output(file, "\n## SHA-2\n\n| |binary_size|Sha256|Sha512|to_account_id|to_neuron_id|\n|--:|--:|--:|--:|--:|--:|\n");

function perf(wasm, title) {
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

perf(sha_mo, "Motoko");
perf(sha_rs, "Rust");
