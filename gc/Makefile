APP = gc

.PHONY: all build perf
all: build perf

build:
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 1"; \
	for f in .dfx/local/canisters/*/*.wasm; do wasm-opt -O1 -o $$f $$f; done; \
	cd ..

perf:
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/perf.sh
