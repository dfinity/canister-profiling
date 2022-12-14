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
	mkdir -p ../_out/basic_dao; \
	cp README.md ../_out/basic_dao; \
	cd ../_out/basic_dao; \
	ic-repl ../../basic_dao/motoko/perf.sh; \
	ic-repl ../../basic_dao/rust/perf.sh
