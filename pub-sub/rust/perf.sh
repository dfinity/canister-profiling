#!ic-repl
load "../../prelude.sh";

let pub_wasm = wasm_profiling(".dfx/local/canisters/pub/pub.wasm");
let sub_wasm = wasm_profiling(".dfx/local/canisters/sub/sub.wasm");
let pub = install(pub_wasm, encode (), null);
let sub = install(sub_wasm, encode (), null);

let file = "README.md";

let caller = call sub.setup_subscribe(pub, "Apples");
flamegraph(sub, "Subscribe Apples", "rs_subscribe.svg");
let callee_cost = flamegraph(pub, "Register subscriber (called by sub canister)", "rs_pub_register.svg");
output(file, stringify("|Rust|", pub_wasm.size(), "|", sub_wasm.size(), "|[caller (", __cost_caller, ")](rs_subscribe.svg) / [callee (", callee_cost, ")](rs_pub_register.svg)|"));

let caller = call pub.publish(record { topic = "Apples"; value = 42 });
flamegraph(pub, "Publish Apples", "rs_publish.svg");
call sub.get_count();
assert _ == (42 : nat64);
let callee_cost = flamegraph(sub, "Update subscriber (callback from pub canister)", "rs_sub_update.svg");
output(file, stringify("[caller (", __cost_caller, ")](rs_publish.svg) / [callee (", callee_cost, ")](rs_sub_update.svg)|\n"));
