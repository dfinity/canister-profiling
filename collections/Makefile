APP = collections

.PHONY: all motoko rust build perf
all: build perf

motoko:
	cd motoko; \
	envsubst < mops.template.toml > mops.toml; \
	mops install; \
	dfx canister create --all; \
	dfx build; \
	rm mops.toml; \
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
	ic-repl ../../$(APP)/perf.sh
