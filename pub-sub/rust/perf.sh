#!ic-repl
load "../../prelude.sh";

let pub = install(wasm_profiling(".dfx/local/canisters/pub/pub.wasm"), encode (), null);
let sub = install(wasm_profiling(".dfx/local/canisters/sub/sub.wasm"), encode (), null);

let file = "README.md";

call sub.setup_subscribe(pub, "Apples");
output(file, stringify("|Rust|[caller (", __cost__, ")](rs_subscribe.svg) / [callee](rs_pub_register.svg)|"));
flamegraph(sub, "Subscribe Apples", "rs_subscribe.svg");
flamegraph(pub, "Register subscriber (called by sub canister)", "rs_pub_register.svg");

call pub.publish(record { topic = "Apples"; value = 42 });
output(file, stringify("[caller (", __cost__, ")](rs_publish.svg) / [callee](rs_sub_update.svg)|\n"));
flamegraph(pub, "Publish Apples", "rs_publish.svg");
call sub.get_count();
assert _ == (42 : nat64);
flamegraph(sub, "Update subscriber (callback from pub canister)", "rs_sub_update.svg");
