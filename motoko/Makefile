include ../*.mk

.PHONY: all build perf
all: build perf

build:
	$(call build_with_mops,motoko)

perf:
	$(call perf_two,motoko,gc.sh,classes.sh)
