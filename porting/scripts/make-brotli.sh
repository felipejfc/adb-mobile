#!/bin/bash

. "$(dirname $0)/defines.sh";

cmake_root=$SOURCE_ROOT/external/brotli/out;

# Clean built products
[[ -d "$cmake_root" ]] && rm -rfv "$cmake_root";
mkdir -pv "$cmake_root";

cd "$cmake_root" || exit;

cmake .. -G Xcode -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE -DPLATFORM=$PLATFORM  \
	-DDEPLOYMENT_TARGET=$DEPLOYMENT_TARGET -DBROTLI_BUNDLED_MODE=1;
cmake --build . --config Debug --parallel 8 \
	--target brotlidec-static --target brotlienc-static --target brotlicommon-static;
find . -name "*.a" -exec cp -av {} $FULL_OUTPUT \;
