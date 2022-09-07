.PHONY: all motoko rust build perf
all: perf

motoko:
	pushd motoko; \
	dfx canister create --all; \
	dfx build; \
	popd

rust:
	pushd rust; \
	dfx canister create --all; \
	dfx build; \
	popd

build: motoko rust

perf: build
	mkdir -p _out; \
	pushd _out; \
	ic-repl ../collections.sh; \
	popd
