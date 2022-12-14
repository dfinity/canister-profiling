#!ic-repl
load "../../prelude.sh";

let pub = install(wasm_profiling(".dfx/local/canisters/pub/pub.wasm"), encode (), null);
let sub = install(wasm_profiling(".dfx/local/canisters/sub/sub.wasm"), encode (), null);

let file = "README.md";
output(file, "\n| |subscribe|publish|\n|--|--:|--:|\n");

let caller = call sub.init(stringify(pub), "Apples");
flamegraph(sub, "Subscribe Apples", "mo_subscribe.svg");
let callee_cost = flamegraph(pub, "Register subscriber (called by sub canister)", "mo_pub_register.svg");
output(file, stringify("|Motoko|[caller (", __cost_caller, ")](mo_subscribe.svg) / [callee (", callee_cost, ")](mo_pub_register.svg)|"));

let caller = call pub.publish(record { topic = "Apples"; value = 42 });
flamegraph(pub, "Publish Apples", "mo_publish.svg");
call sub.getCount();
assert _ == (42 : nat);
let callee_cost = flamegraph(sub, "Update subscriber (callback from pub canister)", "mo_sub_update.svg");
output(file, stringify("[caller (", __cost_caller, ")](mo_publish.svg) / [callee (", callee_cost, ")](mo_sub_update.svg)|\n"));
