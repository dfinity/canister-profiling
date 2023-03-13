APP = collections

.PHONY: all motoko rust build perf
all: build perf

motoko:
	cd motoko; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 4"; \
	pushd .dfx/local/canisters; \
	$(foreach f, $(wildcard *), wasm-opt -O4 -o $(f)/$(f).wasm $(f)/$(f).wasm;); \
	popd; \
	cd ..

rust:
	cd rust; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 4"; \
	pushd .dfx/local/canisters; \
	$(foreach f, $(wildcard *), wasm-opt -O4 -o $(f)/$(f).wasm $(f)/$(f).wasm;); \
	popd; \
	cd ..

build: motoko rust

perf:
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/perf.sh
