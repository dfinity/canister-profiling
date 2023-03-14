APP = collections

.PHONY: all motoko rust build perf
all: build perf

motoko:
	cd motoko; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 4"; \
	$(foreach f, $(wildcard .dfx/local/canisters/*/*.wasm), echo $(f);) \
	cd ..

rust:
	cd rust; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 4"; \
	$(foreach f, $(wildcard .dfx/local/canisters/*/*.wasm), echo $(f);) \
	cd ..

build: motoko rust

perf:
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/perf.sh
