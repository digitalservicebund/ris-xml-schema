CONTAINER_ENGINE := $(shell command -v docker 2>/dev/null || command -v podman 2>/dev/null)
ifeq ($(CONTAINER_ENGINE),)
$(error Neither docker nor podman is available)
endif

ifeq ($(notdir $(CONTAINER_ENGINE)),docker)
RUN := $(CONTAINER_ENGINE) compose run --rm --build --quiet-build --user "$$(id -u):$$(id -g)"
else
RUN := $(CONTAINER_ENGINE) compose --podman-build-args=--quiet run --rm --build --user 0:0
endif

.PHONY: patch-ldml verify-ldml

patch-ldml verify-ldml:
	$(RUN) $@
