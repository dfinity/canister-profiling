#!ic-repl
load "../../prelude.sh";

let pub_wasm = wasm_profiling(".dfx/local/canisters/pub/pub.wasm");
let sub_wasm = wasm_profiling(".dfx/local/canisters/sub/sub.wasm");
let pub = install(pub_wasm, encode (), null);
let sub = install(sub_wasm, encode (), null);

let file = "README.md";
output(file, "\n| |pub_binary_size|sub_binary_size|subscribe_caller|subscribe_callee|publish_caller|publish_callee|\n|--|--:|--:|--:|--:|--:|--:|\n");

let caller = call sub.init(stringify(pub), "Apples");
flamegraph(sub, "Subscribe Apples", "mo_subscribe.svg");
let callee_cost = flamegraph(pub, "Register subscriber (called by sub canister)", "mo_pub_register.svg");
output(file, stringify("|Motoko|", pub_wasm.size(), "|", sub_wasm.size(), "|[", __cost_caller, "](mo_subscribe.svg)|[", callee_cost, "](mo_pub_register.svg)|"));

let caller = call pub.publish(record { topic = "Apples"; value = 42 });
flamegraph(pub, "Publish Apples", "mo_publish.svg");
call sub.getCount();
assert _ == (42 : nat);
let callee_cost = flamegraph(sub, "Update subscriber (callback from pub canister)", "mo_sub_update.svg");
output(file, stringify("[", __cost_caller, "](mo_publish.svg)|[", callee_cost, "](mo_sub_update.svg)|\n"));
