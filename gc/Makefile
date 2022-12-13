.PHONY: all build perf
all: build perf

build:
	dfx canister create --all; \
	dfx build; \
	cd ..

perf:
	mkdir -p ../_out/gc; \
	cd ../_out/gc; \
	ic-repl ../../gc/perf.sh
