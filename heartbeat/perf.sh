#!ic-repl
load "../prelude.sh";

let heartbeat_mo = wasm_profiling("motoko/.dfx/local/canisters/heartbeat/heartbeat.wasm");
let timer_mo = wasm_profiling("motoko/.dfx/local/canisters/timer/timer.wasm");
let heartbeat_rs = wasm_profiling("rust/.dfx/local/canisters/heartbeat/heartbeat.wasm");
let timer_rs = wasm_profiling("rust/.dfx/local/canisters/timer/timer.wasm");

let file = "README.md";

function heartbeat_perf(wasm, title) {
  let cid = install(wasm, encode (), null);
  let svg = stringify(title, "_heartbeat.svg");
  let cost = flamegraph(cid, stringify(title, "_heartbeat"), svg);
  output(file, stringify("|", title, "|[", cost, "](", svg, ")|\n"));
};
function timer_perf(wasm, title) {
  let cid = install(wasm, encode (), null);
  output(file, stringify("|", title, "|"));
  
  let tid = call cid.setTimer(0);
  call cid.__toggle_entry();
  // A second update call can usually capture both the job and setTimer, but it is flaky.
  let svg = stringify(title, "_setTimer.svg");
  let cost = flamegraph(cid, stringify(title, ".setTimer(0)"), svg);
  output(file, stringify("[", cost, "](", svg, ")|"));

  call cid.__toggle_entry();
  let tid = call cid.setTimer(10);
  call cid.cancelTimer(tid);
  let svg = stringify(title, "_cancelTimer.svg");
  flamegraph(cid, stringify(title, ".cancelTimer"), svg);
  output(file, stringify("[", __cost__, "](", svg, ")|\n"));
};

output(file, "\n## Heartbeat\n\n| |heartbeat|\n|--:|--:|\n");
heartbeat_perf(heartbeat_mo, "Motoko");
heartbeat_perf(heartbeat_rs, "Rust");

output(file, "\n## Timer\n\n| |setTimer|cancelTimer|\n|--:|--:|--:|\n");
timer_perf(timer_mo, "Motoko");
timer_perf(timer_rs, "Rust");
