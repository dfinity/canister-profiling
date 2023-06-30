APP = heartbeat

.PHONY: all motoko rust build perf
all: build perf

motoko:
	cd motoko; \
	envsubst < mops.template.toml > mops.toml; \
	mops install; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with ic-wasm level 3"; \
	for f in .dfx/local/canisters/*/*.wasm; do ic-wasm -o $$f $$f shrink --optimize O3 --keep-name-section; done; \
	rm mops.toml; \
	cd ..

rust:
	cd rust; \
	dfx canister create --all; \
	dfx build; \
	echo "Optimize with ic-wasm level 3"; \
	for f in .dfx/local/canisters/*/*.wasm; do ic-wasm -o $$f $$f shrink --optimize O3 --keep-name-section; done; \
	cd ..

build: motoko rust

perf:
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/perf.sh
