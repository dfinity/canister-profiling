include ../*.mk

.PHONY: all motoko rust build perf
all: build perf

motoko:
	$(call build_with_mops,motoko)

rust:
	$(call build,rust)

build: motoko rust

perf:
	$(call perf_two,pub-sub,motoko/perf.sh,rust/perf.sh)
