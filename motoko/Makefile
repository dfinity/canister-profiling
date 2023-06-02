APP = motoko

.PHONY: all build perf
all: build perf

build:
	envsubst < mops.template.toml > mops.toml; \
	mops install; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with wasm-opt level 3"; \
	for f in .dfx/local/canisters/*/*.wasm; do wasm-opt -O3 -g -o $$f $$f; done; \
	rm mops.toml; \
	cd ..

perf:
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/gc.sh; \
	ic-repl ../../$(APP)/classes.sh

clean:
	rm *.wasm && rm mops.toml
