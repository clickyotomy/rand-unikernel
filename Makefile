SHELL     = /bin/bash
VERSION   = v0.1
PROG_NAME = rand
REGISTRY  = ghcr.io
NAMESPACE = clickyotomy
KERN_NAME = $(REGISTRY)/$(NAMESPACE)/$(PROG_NAME)-unikernel:$(VERSION)
KUBE_NAME = $(REGISTRY)/$(NAMESPACE)/$(PROG_NAME)-unikernel:k8s-$(VERSION)

CC        = $(shell which clang)
FMT       = $(shell which clang-format)
KRAFT     = $(shell which kraft)
DOCKER    = $(shell which docker)

ARCH      ?= $(shell uname -m)
ARCH_ALT  = $(shell echo $(ARCH) | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)

VMM       = qemu
CFLAGS    = -Wall -Werror -Wextra -pedantic -fPIC -static-pie
KFLAGS    = --plat $(VMM) --arch $(ARCH)
PFLAGS    = --platform="linux/$(ARCH_ALT)"

default: $(PROG_NAME)

$(PROG_NAME): $(PROG_NAME).c
	$(CC) $(CFLAGS) -o $@ $<

kbuild:
	$(KRAFT) build $(KFLAGS)

krun: kbuild
	$(KRAFT) run --rm $(KFLAGS)

kpkg: kbuild
	$(KRAFT) pkg $(KFLAGS) --as oci --push --name $(KERN_NAME)

k8s: kpkg
	$(shell echo 'FROM --platform="$(VMM)/$(ARCH)" $(KERN_NAME)' > Dockerfile)
	$(DOCKER) buildx build $(PFLAGS) -t $(KUBE_NAME) .
	$(DOCKER) push $(KUBE_NAME)

format:
	$(FMT) -i *.c

clean:
	$(KRAFT) clean --proper .
	/bin/rm -rf .unikraft .config.$(PROG_NAME)* Dockerfile

.PHONY: default kbuild krun kpkg k8s format clean
