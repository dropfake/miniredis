.PHONY: test testrace int ci clean help
test: ### Run unit tests
	go test ./...

testrace: ### Run unit tests with race detector
	go test -race ./...

int: ### Run integration tests (doesn't download redis server)
	${MAKE} -C integration int

ci: ### Run full tests suite (including download and compilation of proper redis server)
	${MAKE} test
	${MAKE} -C integration redis_src/redis-server int
	${MAKE} testrace

clean: ### Clean integration test files and remove compiled redis from integration/redis_src
	${MAKE} -C integration clean

help:
ifeq ($(UNAME), Linux)
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
else
	@# this is not tested, but prepared in advance for you, Mac drivers
	@awk -F ':.*###' '$$0 ~ FS {printf "%15s%s\n", $$1 ":", $$2}' \
		$(MAKEFILE_LIST) | grep -v '@awk' | sort
endif

