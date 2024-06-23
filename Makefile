eSHELL        = /bin/bash
VERSION      = v0.1
PROG_NAME    = rand
REPO_NAME    = clickyotomy/$(PROG_NAME)-unikernel
CC           = $(shell which gcc)
DOCKER       = $(shell which docker)
FMT          = $(shell which clang-format)
CFLAGS       = -Wall -Werror -Wextra -pedantic -fPIC -static-pie
DOCKER_FLAGS = --platform="linux/arm64" --build-arg="PROG_NAME=$(PROG_NAME)"

default: $(PROG_NAME)

$(PROG_NAME): $(PROG_NAME).c
	$(CC) $(CFLAGS) -o $@ $<

docker:
	$(DOCKER) build $(DOCKER_FLAGS) . -t $(REPO_NAME):$(VERSION)
	# $(DOCKER) push $(REPO_NAME):$(VERSION)

format:
	$(FMT) -i *.c

clean:
	/bin/rm -rf .unikraft .config.$(PROG_NAME)* Makefile.uk

.PHONY: default format clean
