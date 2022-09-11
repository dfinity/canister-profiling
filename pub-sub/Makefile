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
	mkdir -p ../_out/pub-sub; \
	cd ../_out/pub-sub; \
	ic-repl ../../pub-sub/motoko/perf.sh; \
	ic-repl ../../pub-sub/rust/perf.sh
