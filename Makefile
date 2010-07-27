PREFIX ?= /usr/local

main_dir = ${DESTDIR}${PREFIX}

build/icli.1: bin/icli
	mkdir -p build
	pod2man $< > $@

install: build/icli.1
	mkdir -p ${main_dir}/bin ${main_dir}/share/man/man1
	cp bin/icli ${main_dir}/bin/icli
	cp build/icli.1 ${main_dir}/share/man/man1/icli.1
	chmod 755 ${main_dir}/bin/icli
	chmod 644 ${main_dir}/share/man/man1/icli.1


test:
	@prove

uninstall:
	rm -f ${main_dir}/bin/icli
	rm -f ${main_dir}/share/man/man1/icli.1

clean:
	rm -rf build

.PHONY: clean install test uninstall
