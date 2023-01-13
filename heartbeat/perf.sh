#!ic-repl
load "../prelude.sh";

let motoko = wasm_profiling("motoko/.dfx/local/canisters/heartbeat/heartbeat.wasm");
let timer_mo = wasm_profiling("motoko/.dfx/local/canisters/timer/timer.wasm");
let rust = wasm_profiling("rust/.dfx/local/canisters/heartbeat/heartbeat.wasm");

let file = "README.md";

function heartbeat_perf(wasm, title) {
  let cid = install(wasm, encode (), null);
  let file = stringify("heartbeat_", title);
  let cost = flamegraph(cid, stringify(title, "_heartbeat"), file);
  output(file, stringify("|", title, "|[", cost, "](", file, ".svg)", "|\n"));
};
function timer_perf(wasm, title) {
  let cid = install(wasm, encode (), null);
  output(file, stringify("|", title, "|"));
  
  call cid.setTimer(0);
  // A second update call can usually capture both the job and setTimer, but it is flaky.
  let tid = call cid.setTimer(10);
  let svg = stringify(title, "_setTimer.svg");
  output(file, stringify("[", __cost_tid, "](", svg, ")|"));
  flamegraph(cid, stringify(title, ".setTimer(0)"), svg);

  call cid.cancelTimer(tid);
  let svg = stringify(title, "_cancelTimer.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|\n"));
  flamegraph(cid, stringify(title, ".cancelTimer"), svg);
};

output(file, "\n| |heartbeat|\n|--:|--:|\n");
heartbeat_perf(motoko, "Motoko");
heartbeat_perf(rust, "Rust");

output(file, "\n| |setTimer|cancelTimer|\n|--:|--:|--:|\n");
timer_perf(timer_mo, "Motoko");
