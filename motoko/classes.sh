#!ic-repl
load "../prelude.sh";

let class = wasm_profiling("motoko/.dfx/local/canisters/classes/classes.wasm");
let map = install(class, encode (), null);

let file = "README.md";
output(file, "\n\n## Actor class\n\n| |binary size|put new bucket|put existing bucket|get|\n|--|--:|--:|--:|--:|\n");

call map.put(1, "Test1");
flamegraph(map, "Map.put(1, \"Test1\")", "map_put.svg");
output(file, stringify("|Map|", class.size(), "|[", __cost__, "](map_put.svg)|"));

call map.put(5, "Test5");
flamegraph(map, "Map.put(5, \"Test5\") (no new instantiation)", "map_put_existing.svg");
output(file, stringify("[", __cost__, "](map_put_existing.svg)|"));

call map.get(5);
assert _ == opt "Test5";
flamegraph(map, "Map.get(5)", "map_get.svg");
output(file, stringify("[", __cost__, "](map_get.svg)|\n"));
