## You can use CC CFLAGS LD LDFLAGS CXX CXXFLAGS AR RANLIB READELF STRIP after include env.mak
include /env.mak

LINUX=$(SysRootLib)/modules/DSM-$(DSM_SHLIB_MAJOR).$(DSM_SHLIB_MINOR)/build
ZFS=zfs-2.2.5

.PHONY: all install $(ZFS)

all: $(ZFS)

$(ZFS).tar.gz:
	wget https://github.com/openzfs/zfs/releases/download/$(ZFS)/$(ZFS).tar.gz

$(ZFS)/configure: $(ZFS).tar.gz
	tar xf $<
	cd $(ZFS) && patch -p1 < ../compiler_compat.patch
	touch $@

$(ZFS)/Makefile: $(ZFS)/configure
	cd $(ZFS) && ./configure $(subst ",,$(ConfigOpt)) --with-python=3.8 \
		--with-linux="${LINUX}" --program-prefix="" --with-zfsexecdir=/usr/local/lib/zfs --localstatedir=/var \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" \
		CC="${CC}" CXX="${CXX}" LD="${LD}" AR="${AR}" RANLIB="${RANLIB}" \
		NM="${NM}" READELF="${READELF}"

$(ZFS): $(ZFS)/Makefile
	@echo "===>" $@
	$(MAKE) -C $@ INSTALLDIR=$(INSTALLDIR)/$@ DESTDIR=$(DESTDIR) PREFIX=$(PREFIX) initconfdir=/usr/local/etc/zfs-default $(MAKECMDGOALS);
	@echo "<===" $@

packageinstall:

install: $(ZFS)

clean:
