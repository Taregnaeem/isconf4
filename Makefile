PREFIX=/var/isconf
# tmpdir=/tmp/isconf-make.tmp
version=`cat version`
revision=`cat revision`
tarname=isconf-$(version).$(revision)
tarball=/tmp/$(tarname).tar.gz

all:

install:
	python ./setup.py install

start:
	/etc/init.d/isconf stop
	sleep 1
	/etc/init.d/isconf start
	sleep 5

ctags:
	# requires Exuberant ctags 
	# ctags --language-force=python bin/isconf
	cd bin; ctags --language-force=python isconf

XXXtar: 
	./update-revision
	rm -rf $(tmpdir)
	mkdir -p $(tmpdir)/$(tarname)
	cp -a . $(tmpdir)/$(tarname)
	tar -C $(tmpdir) --exclude=*.pyc --exclude=*.swp --exclude=*.swo --exclude=.coverage -czvf $(tarball) $(tarname)
	rm -rf $(tmpdir)

sdist:
	./update-revision
	python setup.py sdist
	mv dist/$(tarname).tar.gz $(tarball)

ship: sdist
	scp $(tarball) root@trac.t7a.org:/var/trac/isconf/pub

test:
	cd t && time make

%:
	cd t && $(MAKE) $*
