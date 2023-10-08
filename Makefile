APPS = collections

all:
	$(foreach test_dir,$(APPS),make -C $(test_dir) &&) true
