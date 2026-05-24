@echo off
REM VS2022 Build Script for EncFSMP CLI
REM Directly uses VS2022 without SB scripts
REM Builds only CLI tool (no wxWidgets required)

REM Set VS2022 paths
SET VSVARSALL_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat
SET CMAKE_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin

REM Set Visual Studio environment
CALL "%VSVARSALL_PATH%" x64

REM Add CMake to PATH
SET PATH=%PATH%;%CMAKE_PATH%

REM Dependency paths (adjust these to match your environment)
SET DEPENDENCIES_PATH=C:\Users\roger\src\o\EncFSMP\libs
SET "DEPENDENCIES_PATH_FWD=%DEPENDENCIES_PATH:\=/%"

REM Boost
SET BOOST_ROOT=%DEPENDENCIES_PATH_FWD%

REM OpenSSL
SET OPENSSL_ROOT_DIR=%DEPENDENCIES_PATH_FWD%

REM Google Test (optional for CLI)
SET GOOGLE_TEST_ROOT=%DEPENDENCIES_PATH%
SET GOOGLE_TEST_INCLUDE=%DEPENDENCIES_PATH_FWD%/include
SET GOOGLE_TEST_LIBRARY=optimized;%DEPENDENCIES_PATH%/gtest_rel/gtest.lib;debug;%DEPENDENCIES_PATH%/gtest_deb/gtest.lib

REM PFM
SET PFM_ROOT=C:\Users\roger\src\o\EncFSMP\pfmkit

REM ENCFSMP_ADDITIONAL_LINK_LIBRARIES
SET ENCFSMP_ADDITIONAL_LINK_LIBRARIES=%DEPENDENCIES_PATH_FWD%/lib/libpng16_static.lib;%DEPENDENCIES_PATH_FWD%/lib/libjpeg.lib;%DEPENDENCIES_PATH_FWD%/lib/tiff.lib;%DEPENDENCIES_PATH_FWD%/lib/zlibstatic.lib

REM Create build directory and run CMake
IF NOT EXIST build_x64_sb_2022_cli mkdir build_x64_sb_2022_cli
cd build_x64_sb_2022_cli
cmake -Wno-dev -G "Visual Studio 17 2022" -DCMAKE_CONFIGURATION_TYPES=Release;RelWithDebInfo;Debug -DCMAKE_GENERATOR_PLATFORM="x64" -DBUILD_GUI=OFF -DPFM_ROOT=%PFM_ROOT% -DCMAKE_PREFIX_PATH=%DEPENDENCIES_PATH_FWD% -DOPENSSL_ROOT_DIR=%OPENSSL_ROOT_DIR% -DGOOGLE_TEST_INCLUDE=%GOOGLE_TEST_INCLUDE% -DGOOGLE_TEST_LIBRARY=%GOOGLE_TEST_LIBRARY% -DENCFSMP_ADDITIONAL_LINK_LIBRARIES=%ENCFSMP_ADDITIONAL_LINK_LIBRARIES% ..\src

cd ..
pause