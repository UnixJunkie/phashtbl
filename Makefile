.PHONY: build install uninstall reinstall

build:
	jbuilder build @install -j 16

clean:
	rm -rf _build

edit:
	emacs src/*.ml TODO commands.sh &

install: build
	jbuilder install

uninstall:
	jubilder uninstall

reinstall: uninstall install
