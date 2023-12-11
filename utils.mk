define ic-wasm
	echo "Optimize with ic-wasm"; \
	for f in $(1)/*/*.wasm; do ic-wasm -o $$f $$f optimize O3 --keep-name-section; done
endef

define build_with_mops
	set -e; \
	cd $(1); \
	envsubst < mops.template.toml > mops.toml; \
	mops install; \
	dfx canister create --all; \
	dfx ledger fabricate-cycles --t 100 --canister $$(dfx identity get-wallet); \
	dfx build; \
	rm mops.toml; \
	$(call ic-wasm,.dfx/local/canisters/); \
	cd ..
endef

define build
	set -e; \
	cd $(1); \
	dfx canister create --all; \
	dfx ledger fabricate-cycles --t 100 --canister $$(dfx identity get-wallet); \
	dfx build; \
	$(call ic-wasm,.dfx/local/canisters/); \
	cd ..
endef

define prepare_perf
	mkdir -p ../_out/$(1); \
	cp README.md ../_out/$(1); \
	cd ../_out/$(1)
endef

define perf
	set -e; \
	$(call prepare_perf,$(1)); \
	ic-repl --use-new-metering ../../$(1)/$(2); \
	du -h ../../_out
endef

define perf_two
	set -e; \
	$(call prepare_perf,$(1)); \
	ic-repl --use-new-metering ../../$(1)/$(2); \
	ic-repl --use-new-metering ../../$(1)/$(3); \
	du -h ../../_out
endef
