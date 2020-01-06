.PHONY: build install uninstall reinstall doc test

build:
	dune build @install -j 16

clean:
	rm -rf _build doc/*

edit:
	emacs src/*.ml TODO commands.sh &

install: build
	dune install

uninstall:
	jubilder uninstall

reinstall: uninstall install

doc:
	mkdir -p doc
	ocamldoc -html -d doc src/phashtbl.mli

test:
	dune build _build/default/src/test.exe
	_build/default/src/test.exe
