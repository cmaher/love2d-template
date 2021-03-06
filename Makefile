# parallel build
NPROCS = $(shell grep -c 'processor' /proc/cpuinfo)
MAKEFLAGS += -j$(NPROCS)

VERSION=0.1.0
LOVE_VERSION=11.4
NAME=TODO_TITLE
ITCH_ACCOUNT=TODO_ITCH_ACCOUNT
URL=TODO_URL
AUTHOR=TODO_AUTHOR_NAME
DESCRIPTION=TODO_DESCRIPTION

HEIGHT=640
WIDTH=880
CANVAS_COLOUR="26,16,16"
TEXT_COLOUR="250,248,240"

LIBS_LUA := $(shell find lib -name '*.lua')
LIBS_FNL := $(shell find lib -name '*.fnl')
LUA := $(wildcard *.lua)
SRC :=  $(shell find src -name '*.fnl')
OUT := $(patsubst src/%.fnl,build/%.lua,$(SRC))
OUT_LIBS := $(patsubst %.fnl,build/%.lua,$(LIBS_FNL))

FENNEL := ./.luarocks/bin/fennel\
	--plugin $(PWD)/src/maru/prelude-macros.fnl \
	--add-macro-path ./macros/?.fnl\
	--add-macro-path ./macros/?/init.fnl
LUAROCKS := luarocks --lua-version=5.1 --lua-dir=${LUA_DIR} --tree=./.luarocks

run:
	love . --debug --fennel --repl

.PHONY: test
test:
	love . --debug --fennel --test

build: compile
	cp main.lua conf.lua build
	rm -rf build/assets build/.luarocks
	ln -s $(PWD)/assets build/assets
	ln -s $(PWD)/.luarocks build/.luarocks
	cp -R $(PWD)/lib/* build/lib

# call this instead of clean build because of parallel processing
rebuild: clean
	$(MAKE) build

compile: $(OUT) $(OUT_LIBS) $(OUT_ENTS)

count:
	cloc src/*.fnl --force-lang=clojure

clean:
	rm -rf releases build

build/%.lua: src/%.fnl
	mkdir -p $(dir $@)
	$(FENNEL) --compile --correlate $< > $@

build/lib/%.lua: lib/%.fnl
	mkdir -p $(dir $@)
	$(FENNEL) --compile --correlate $< > $@

LOVEFILE=$(PWD)/releases/$(NAME)-$(VERSION).love

# removes GPLv3 code before packaging for release
$(LOVEFILE): build
	mkdir -p releases/
	rm -f build/lib/stdio.fnl build/lib/stdio.lua
	cd build && find -L . -type f | LC_ALL=C sort | env TZ=UTC zip -r -q -9 -X $@ -@

love: $(LOVEFILE)

# platform-specific distributables

REL=$(PWD)/buildtools/love-release.sh # https://p.hagelb.org/love-release.sh
FLAGS=-a "$(AUTHOR)" --description $(DESCRIPTION) \
	--love $(LOVE_VERSION) --url $(URL) --version $(VERSION) --lovefile $(LOVEFILE)

releases/$(NAME)-$(VERSION)-x86_64.AppImage: $(LOVEFILE)
	cd buildtools/appimage && ./build.sh $(LOVE_VERSION) $(LOVEFILE)
	mv buildtools/appimage/game-x86_64.AppImage $@

releases/$(NAME)-$(VERSION)-macos.zip: $(LOVEFILE)
	$(REL) $(FLAGS) -M
	mv releases/$(NAME)-macos.zip $@

releases/$(NAME)-$(VERSION)-win.zip: $(LOVEFILE)
	$(REL) $(FLAGS) -W32
	mv releases/$(NAME)-win32.zip $@


releases/$(NAME)-$(VERSION)-web.zip: $(LOVEFILE)
	buildtools/love-js/love-js.sh releases/$(NAME)-$(VERSION).love $(NAME) -v=$(VERSION) -a=$(AUTHOR) -o=releases -x=$(WIDTH) -y=$(HEIGHT) -c=$(CANVAS_COLOUR) -t=$(TEXT_COLOUR)

releases/$(NAME)-$(VERSION)-source.zip:
	find assets buildtools lib ./conf.lua ./makefile ./license.txt ./main.lua ./readme.org src buildtools -type f | LC_ALL=C sort | env TZ=UTC zip -r -q -9 -X $@ -@

runweb: $(LOVEFILE)
	buildtools/love-js/love-js.sh releases/$(NAME)-$(VERSION).love $(NAME) -v=$(VERSION) -a=$(AUTHOR) -o=releases -x=$(WIDTH) -y=$(HEIGHT) -c=$(CANVAS_COLOUR) -t=$(TEXT_COLOUR) -r

linux: releases/$(NAME)-$(VERSION)-x86_64.AppImage
mac: releases/$(NAME)-$(VERSION)-macos.zip
windows: releases/$(NAME)-$(VERSION)-win.zip
web: releases/$(NAME)-$(VERSION)-web.zip
source: releases/$(NAME)-$(VERSION)-source.zip

# If you release on itch.io, you should install butler:
# https://itch.io/docs/butler/installing.html

uploadlinux: releases/$(NAME)-$(VERSION)-x86_64.AppImage
	butler push $^ $(ITCH_ACCOUNT)/$(NAME):linux --userversion $(VERSION)
uploadmac: releases/$(NAME)-$(VERSION)-macos.zip
	butler push $^ $(ITCH_ACCOUNT)/$(NAME):mac --userversion $(VERSION)
uploadwindows: releases/$(NAME)-$(VERSION)-win.zip
	butler push $^ $(ITCH_ACCOUNT)/$(NAME):windows --userversion $(VERSION)
uploadlove: releases/$(NAME)-$(VERSION).love
	butler push $^ $(ITCH_ACCOUNT)/$(NAME):love --userversion $(VERSION)
uploadweb: releases/$(NAME)-$(VERSION)-web.zip
	butler push $^ $(ITCH_ACCOUNT)/$(NAME):web --userversion $(VERSION)
uploadsource: releases/$(NAME)-$(VERSION)-source.zip
	butler push $^ $(ITCH_ACCOUNT)/$(NAME):source --userversion $(VERSION)


upload: uploadlinux uploadmac uploadwindows uploadweb uploadlove

release: linux web mac windows upload

pin-deps:
	$(LUAROCKS) list --porcelain > .luarocks.lock

deps:
	LUAROCKS="$(LUAROCKS)" ./buildtools/deps.sh

