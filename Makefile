## You can use CC CFLAGS LD LDFLAGS CXX CXXFLAGS AR RANLIB READELF STRIP after include env.mak
include /env.mak

LINUX := $(SysRootLib)/modules/DSM-$(DSM_SHLIB_MAJOR).$(DSM_SHLIB_MINOR)/build
ZFS := zfs-2.2.5

.PHONY: all install packageinstall $(ZFS)

all: $(ZFS)

$(ZFS).tar.gz:
	wget https://github.com/openzfs/zfs/releases/download/$(ZFS)/$(ZFS).tar.gz

$(ZFS)/configure: $(ZFS).tar.gz
	tar xf $<
	cd $(ZFS) && patch -p1 < ../patches/compiler_compat.patch
	cd $(ZFS) && patch -p1 < ../patches/zfs-mount-service.patch
	cd $(ZFS) && patch -p1 < ../patches/getzoneid-enoent.patch
	touch $@

$(ZFS)/Makefile: $(ZFS)/configure
	cd $(ZFS) && ./configure $(subst ",,$(ConfigOpt)) \
		--program-prefix="" --with-linux="${LINUX}" --with-python=3.8 \
		--prefix=/usr --localstatedir=/var --sysconfdir=/etc \
		--enable-systemd \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" \
		CC="${CC}" CXX="${CXX}" LD="${LD}" AR="${AR}" \
		RANLIB="${RANLIB}" NM="${NM}" READELF="${READELF}"

$(ZFS): $(ZFS)/Makefile
	@echo "===>" $@
	$(MAKE) -C $@ INSTALLDIR=$(INSTALLDIR)/$@ DESTDIR=$(DESTDIR) $(MAKECMDGOALS);
	@echo "<===" $@

packageinstall:

install: $(ZFS)

clean:
