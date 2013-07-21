LUA_DIR=/usr/local
LUA_LIBDIR=$(LUA_DIR)/lib/lua/5.1
LUA_SHAREDIR=$(LUA_DIR)/share/lua/5.1

uninstall:
	rm -rfI $(LUA_SHAREDIR)/solstice
install:
	mkdir -p $(LUA_SHAREDIR)/solstice
	cp -rv src/solstice $(LUA_SHAREDIR)
