APPS = dapps collections crypto pub-sub heartbeat motoko

all:
	$(foreach test_dir,$(APPS),make -C $(test_dir) &&) true

