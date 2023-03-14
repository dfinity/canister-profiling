APP = collections

.PHONY: all motoko rust build perf
all: build perf

motoko:
	cd motoko; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 4"; \
	echo "kento"; \
	for f in .dfx/local/canisters/*; do echo $$f; done; \
	cd ..

rust:
	cd rust; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 4"; \
	cd ..

build: motoko rust

perf:
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/perf.sh
