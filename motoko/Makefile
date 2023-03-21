APP = gc

.PHONY: all build perf
all: build perf

build:
	dfx canister create --all; \
	dfx build; \
	cd ..

perf:
	set -e; \
	mkdir -p ../_out/$(APP); \
	cp README.md ../_out/$(APP); \
	cd ../_out/$(APP); \
	ic-repl ../../$(APP)/gc.sh; \
	ic-repl ../../$(APP)/classes.sh

