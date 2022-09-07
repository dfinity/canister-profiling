.PHONY: all motoko rust build perf
all: perf

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

perf: build
	mkdir -p _out; \
	cd _out; \
	ic-repl ../collections.sh; \
	cd ..
