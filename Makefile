ifeq ($(shell uname -m),arm64)
	EMMYLUA_ARCH ?= arm64
else
	EMMYLUA_ARCH ?= x64
endif

ifeq ($(shell uname -s),Darwin)
	NVIM_PLATFORM := macos-$(shell uname -m)
else
	NVIM_PLATFORM := linux-$(shell uname -m)
endif

NVIM_VERSION := v0.12.0
NVIM_DIR := deps/nvim-$(NVIM_VERSION)
NVIM_ARCHIVE := deps/nvim-$(NVIM_PLATFORM).tar.gz
NVIM_URL := https://github.com/neovim/neovim/releases/download/$(NVIM_VERSION)/nvim-$(NVIM_PLATFORM).tar.gz
NVIM_RUNTIME := $(NVIM_DIR)/share/nvim/runtime

EMMYLUA_VERSION := 0.25.0
EMMYLUA_OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
EMMYLUA_DIR := deps/emmylua-$(EMMYLUA_VERSION)
EMMYLUA_ARCHIVE := deps/emmylua_check-$(EMMYLUA_VERSION)-$(EMMYLUA_OS)-$(EMMYLUA_ARCH).tar.gz
EMMYLUA_URL := https://github.com/EmmyLuaLs/emmylua-analyzer-rust/releases/download/$(EMMYLUA_VERSION)/emmylua_check-$(EMMYLUA_OS)-$(EMMYLUA_ARCH).tar.gz
EMMYLUA_BIN := $(EMMYLUA_DIR)/emmylua_check

.PHONY: emmylua_check
emmylua_check: $(EMMYLUA_BIN) $(NVIM_RUNTIME)
	VIMRUNTIME=$(NVIM_RUNTIME) $(EMMYLUA_BIN) . --ignore 'deps/**/*'

$(EMMYLUA_BIN):
	mkdir -p $(EMMYLUA_DIR)
	curl -L $(EMMYLUA_URL) -o $(EMMYLUA_ARCHIVE)
	tar -xzf $(EMMYLUA_ARCHIVE) -C $(EMMYLUA_DIR)

$(NVIM_RUNTIME):
	mkdir -p $(NVIM_DIR)
	curl -L $(NVIM_URL) -o $(NVIM_ARCHIVE)
	tar -xzf $(NVIM_ARCHIVE) -C $(NVIM_DIR) --strip-components=1
