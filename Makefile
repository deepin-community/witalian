# Makefile for the witalian package
#
# Copyright (C) 1997-2018 Davide Giovanni Maria Salvetti.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# On Debian GNU/Linux System you can find a copy of the GNU General Public
# License in "/usr/share/common-licenses/GPL".

VER = $(shell git tag -l | tail -n 1 | cut -d '/' -f 2)
LANG = italian
CLASSES	= cognomi names nomi others parole sigle surnames words

INSTALL = install -o root -g root
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA    = $(INSTALL) -m 644
INSTALL_DIR     = $(INSTALL) -d

prefix      = /usr/local/
datarootdir = $(prefix)/share
datadir     = $(datarootdir)
mandir      = $(datarootdir)/man
man5dir     = $(mandir)/man5
docdir      = $(datarootdir)/doc/witalian

.PHONY: all
all: build

.PHONY: build
build: $(LANG)

$(LANG): $(addprefix $(LANG).,$(CLASSES))
	cat $(addprefix $(LANG).,$(CLASSES)) | sort | uniq > $@

.PHONY: installdirs
installdirs:
	test -d $(DESTDIR)$(datadir)/dict \
		|| $(INSTALL_DIR) $(DESTDIR)$(datadir)/dict
	test -d $(DESTDIR)$(man5dir) \
		|| $(INSTALL_DIR) $(DESTDIR)$(man5dir)
	test -d $(DESTDIR)$(docdir) \
		|| $(INSTALL_DIR) $(DESTDIR)$(docdir)

.PHONY: install install-strip
install install-strip: $(LANG) installdirs
	$(INSTALL_DATA) $(LANG) $(DESTDIR)$(datadir)/dict/
	$(INSTALL_DATA) $(LANG).5 $(DESTDIR)$(man5dir)/
	$(INSTALL_DATA) README TODO $(DESTDIR)$(docdir)

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(docdir)/TODO
	rm -f $(DESTDIR)$(docdir)/README
	rm -f $(DESTDIR)$(man5dir)/$(LANG).5
	rm -f $(DESTDIR)$(datadir)/dict/$(LANG)

.PHONY: clean distclean mostlyclean maintainer-clean
clean distclean mostlyclean maintainer-clean:
	rm -f $(LANG)

.PHONY: dist
dist:
	git archive --format=tar --prefix=witalian-$(VER)/ HEAD \
		| gzip --best > ../witalian-$(VER).tar.gz

.PHONY: check
check: build
	test -f $(LANG)
