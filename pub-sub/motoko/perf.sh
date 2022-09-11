#!ic-repl
load "../../prelude.sh";

let pub = install(wasm_profiling(".dfx/local/canisters/pub/pub.wasm"), encode (), null);
let sub = install(wasm_profiling(".dfx/local/canisters/sub/sub.wasm"), encode (), null);

call sub.init(stringify(pub), "Apples");
flamegraph(sub, "Subscribe Apples", "subscribe.svg");
flamegraph(pub, "Register subscriber (called by sub canister)", "pub_register.svg");

call pub.publish(record { topic = "Apples"; value = 42 });
flamegraph(pub, "Publish Apples", "publish.svg");
call sub.getCount();
assert _ == (42 : nat);
flamegraph(sub, "Update subscriber (callback from pub canister)", "sub_update.svg");
