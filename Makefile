# You need to run the following to let make work:
#    sudo xcodebuild -license accept

# install the following to /Applications before proceeding:
#     * CreateUserPkg
#     * AutoDMG.app
#     * the OSX installer (Install macOS High Sierra.app)
#     * Xcode.app
# to /Applications before proceeding.

# Put additional big packages (e.g. printer drivers)
# in  ~/Documents/packages.10.12/ before running

OSX := /Applications/Install macOS High Sierra.app
AUTODMG := /Applications/AutoDMG.app/Contents/MacOS/AutoDMG
OUTPUT := $(shell date +%Y%m%d).osx.$(shell sw_vers -productVersion).adminadmin.dmg

default: $(OUTPUT)

prepare:
	sudo pmset -a sleep 180
	sudo pmset -a displaysleep 180
	$(AUTODMG) update

custompkg/custom.pkg:
	cd custompkg && make

$(OUTPUT): prepare custompkg/custom.pkg
	-$(AUTODMG) \
		--log-level 7 \
		--logfile - \
		build \
		-n "root" \
		--filesystem apfs \
		-u -U \
		-o /tmp/output.dmg \
		"$(OSX)" \
		/Applications/Xcode.app \
		/Applications/AutoDMG.app \
		"$(OSX)" \
		"$(PWD)"/custompkg/custom.pkg \
		"$(PWD)"/pkgs/*.pkg && \
		cp /tmp/output.dmg "$(PWD)"/$@

clean:
	rm -f *.dmg /tmp/output.dmg custompkg/*.pkg
