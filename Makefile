all: check-protobuf-version libs libadb.a libadb.include

install-cmake:
	@echo "Installing CMake from DMG..."
	curl -L -o /tmp/cmake-3.31.8-macos-universal.dmg https://github.com/Kitware/CMake/releases/download/v3.31.8/cmake-3.31.8-macos-universal.dmg
	hdiutil attach /tmp/cmake-3.31.8-macos-universal.dmg
	sudo cp -R /Volumes/cmake-3.31.8-macos-universal/CMake.app /Applications/
	hdiutil detach /Volumes/cmake-3.31.8-macos-universal
	rm /tmp/cmake-3.31.8-macos-universal.dmg
	sudo ln -sf /Applications/CMake.app/Contents/bin/cmake /usr/local/bin/cmake
	sudo ln -sf /Applications/CMake.app/Contents/bin/ctest /usr/local/bin/ctest
	sudo ln -sf /Applications/CMake.app/Contents/bin/cpack /usr/local/bin/cpack
	@echo "CMake installed successfully"

brew-install-deps:
	brew install fmt pkgconfig googletest

check-protobuf-version:
	@grep $$(protoc --version | cut -d' ' -f2) porting/protobuf.rb || { echo "* To compile libadb please install protobuf version 28.3 by:" && echo "brew unlink protobuf && brew install porting/protobuf.rb" && echo "" && exit 1; }
	protoc --version
	exit 0

check-golang:
	@which go || { echo "* To compile libadb please install golang by execute:"; echo ""; }

libs:
	[[ -d output ]] || mkdir output && echo "mkdir output"
	make -C porting

libadb.include:
	[[ ! -d output/include ]] && mkdir output/include || echo "make include";
	cp -av porting/adb/include/*.h output/include;

libadb.a:
	rm -fv output/*/*/libadb-full.a || echo ""
	libtool -static -o output/iphoneos/arm64/libadb-full.a output/iphoneos/arm64/*.a
	libtool -static -o output/iphonesimulator/arm64/libadb-full.a output/iphonesimulator/arm64/*.a
