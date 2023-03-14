APPS = dapps collections pub-sub heartbeat gc

all:
	$(foreach test_dir,$(APPS),make -C $(test_dir) &&) true

