.PHONY: all motoko rust build perf
all: build perf

motoko:
	cd motoko; \
	dfx canister create --all; \
	dfx build; \
	cd ..

rust:
	cd rust; \
	dfx canister create --all; \
	dfx build; \
	cd ..

build: motoko rust

perf:
	mkdir -p ../_out/heartbeat; \
	cp README.md ../_out/heartbeat; \
	cd ../_out/heartbeat; \
	ic-repl ../../heartbeat/perf.sh
