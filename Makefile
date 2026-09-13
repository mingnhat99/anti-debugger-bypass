# Pack the extension into a .crx / .zip using Chrome's built-in packer.
#
#   make        -> dist/anti-debugger-bypass-<version_name>.crx
#   make zip    -> dist/anti-debugger-bypass-<version_name>.zip  (for Chrome Web Store upload / load unpacked)
#   make clean  -> remove build artifacts
#
# <version_name> is read from manifest.json ("version_name", falling back
# to "version" when not set), e.g. anti-debugger-bypass-1.1-rc1.crx.
#
# The signing key (extension.pem) is auto-generated on the first build and
# reused afterwards so the extension ID never changes.
# Keep it private - it is git-ignored and must NEVER be committed or lost.

# Chrome/Chromium binary (override with: make CHROME=/path/to/chrome)
CHROME ?= $(shell for c in \
	"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
	"/Applications/Chromium.app/Contents/MacOS/Chromium" \
	"/usr/bin/google-chrome-stable" \
	"/usr/bin/google-chrome" \
	"/usr/bin/chromium-browser" \
	"/usr/bin/chromium"; do \
	if [ -x "$$c" ]; then echo "$$c"; break; fi; done)

NAME      := anti-debugger-bypass
KEY       := extension.pem
STAGE_DIR := build/$(NAME)

# Prefer "version_name" (free-form, e.g. "1.1-rc1"); fall back to "version".
VERSION_NAME := $(shell sed -n 's/.*"version_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' manifest.json)
ifeq ($(VERSION_NAME),)
VERSION_NAME := $(shell sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' manifest.json)
endif
CRX := dist/$(NAME)-$(VERSION_NAME).crx
ZIP := dist/$(NAME)-$(VERSION_NAME).zip

FILES := manifest.json background.js inject.js \
         icon-16.png icon-32.png icon-48.png icon-128.png

.PHONY: all stage crx zip clean

all: crx zip

# Stage extension files into build/anti-debugger-bypass (also used by CI).
stage:
	rm -rf build && mkdir -p $(STAGE_DIR) dist
	cp $(FILES) $(STAGE_DIR)/

crx: stage
	@test -n "$(CHROME)" || { echo "error: Chrome/Chromium not found (run: make CHROME=/path/to/chrome)"; exit 1; }
	@echo ">> Packing with $(CHROME)"
	if [ -f "$(KEY)" ]; then \
		"$(CHROME)" --pack-extension="$(CURDIR)/$(STAGE_DIR)" --pack-extension-key="$(CURDIR)/$(KEY)" \
			|| { echo "error: packing failed"; exit 1; }; \
	else \
		echo ">> No $(KEY) found - generating a new one (keep it safe!)"; \
		"$(CHROME)" --pack-extension="$(CURDIR)/$(STAGE_DIR)" \
			|| { echo "error: packing failed"; exit 1; }; \
		mv "$(STAGE_DIR).pem" "$(KEY)"; \
	fi
	mv -f "$(STAGE_DIR).crx" "$(CRX)"
	@for f in dist/$(NAME)*.crx; do [ "$$f" = "$(CRX)" ] || rm -f "$$f"; done
	@id=$$(openssl rsa -in "$(KEY)" -pubout -outform DER 2>/dev/null \
		| openssl dgst -sha256 -binary | od -An -tx1 | tr -d ' \n' | cut -c1-32 \
		| tr '0123456789abcdef' 'abcdefghijklmnop'); \
	echo ">> Built $(CRX) (extension ID: $$id)"

zip: stage
	cd build && zip -qr "$(CURDIR)/$(ZIP)" $(NAME)
	@for f in dist/$(NAME)*.zip; do [ "$$f" = "$(ZIP)" ] || rm -f "$$f"; done
	@echo ">> Built $(ZIP)"

clean:
	rm -rf build dist
