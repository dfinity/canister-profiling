APP = dapps

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
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/basic_dao.sh; \
	ic-repl ../../$(APP)/nft.sh
