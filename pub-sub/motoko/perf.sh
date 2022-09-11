#!ic-repl
load "../../prelude.sh";

let pub = install(wasm_profiling(".dfx/local/canisters/pub/pub.wasm"), encode (), null);
let sub = install(wasm_profiling(".dfx/local/canisters/sub/sub.wasm"), encode (), null);

let file = "README.md";
output(file, "\n# Publisher Subscriber\n\n| |subscribe|publish|\n|--|--:|--:|\n");

call sub.init(stringify(pub), "Apples");
output(file, stringify("|Motoko|[", __cost__, "](mo_subscribe.svg) [callee](mo_pub_register.svg)|"));
flamegraph(sub, "Subscribe Apples", "mo_subscribe.svg");
flamegraph(pub, "Register subscriber (called by sub canister)", "mo_pub_register.svg");

call pub.publish(record { topic = "Apples"; value = 42 });
output(file, stringify("[", __cost__, "](mo_publish.svg) [callee](mo_sub_update.svg)|\n"));
flamegraph(pub, "Publish Apples", "mo_publish.svg");
call sub.getCount();
assert _ == (42 : nat);
flamegraph(sub, "Update subscriber (callback from pub canister)", "mo_sub_update.svg");
