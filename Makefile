APPS = dapps collections crypto pub-sub heartbeat motoko

all:
	$(foreach test_dir,$(APPS),make -C $(test_dir) &&) true

emit_version:
	for f in _out/*/README.md; do \
	  echo "\n> ## Environment" >> $$f; \
	  (printf "> * "; dfx --version) >> $$f; \
	  (printf "> * "; $$(dfx cache show)/moc --version) >> $$f; \
	  (printf "> * "; rustc --version) >> $$f; \
	  (printf "> * "; ic-repl --version) >> $$f; \
	  (printf "> * "; ic-wasm --version) >> $$f; \
	done
