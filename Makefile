SOURCES8=$(wildcard src/*.s)
OBJECTS8=$(SOURCES8:.s=.o)

LIB_NAME=curl

ifeq ($(CC65_HOME),)
        CC = cl65
        AS = ca65
        LD = ld65
        AR = ar65
else
        CC = $(CC65_HOME)/bin/cl65
        AS = $(CC65_HOME)/bin/ca65
        LD = $(CC65_HOME)/bin/ld65
        AR = $(CC65_HOME)/bin/ar65
endif

all: $(SOURCES8) $(OBJECTS8) tests

init: $(SOURCE)
	./configure

$(OBJECTS8): $(SOURCES8)
	@mkdir target/telestrat/lib/ -p
	@$(AS) -ttelestrat $(@:.o=.s) -o $@ --include-dir src/include -I libs/usr/include/asm/
	@$(AR) r $(LIB_NAME).lib $@
	@mkdir -p build/lib8
	@mkdir -p build/usr/include/
	@mkdir -p build/usr/include/asm
	@cp src/include/$(LIB_NAME).h build/usr/include/curl/
	@cp src/include/$(LIB_NAME).inc build/usr/include/asm/
	@cp $(LIB_NAME).lib build/lib8/

tests:
	@cl65 -I src/include/ -o 1000 -ttelestrat tests/curl.c curl.lib libs/lib8/inet.lib libs/lib8/socket.lib libs/lib8/ch395-8.lib --start-addr \$800
	@cl65 -I src/include/ -o 1256 -ttelestrat tests/curl.c curl.lib libs/lib8/inet.lib libs/lib8/socket.lib libs/lib8/ch395-8.lib --start-addr \$900
	dependencies/orix-sdk/bin/relocbin.py3 -o curl -2 1000 1256
	@rm 1000
	@rm 1256

clean:
	rm src/*.o
	rm curl.lib
