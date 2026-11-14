{ stdenv
, lib
, fetchurl
, runCommand
, src
, cmake
, ninja
, pkg-config
, python3
, git
, glslang
, unzip
, jq
, openssl
, boost
, fmt_11
, nlohmann_json
, lz4
, zlib
, zstd
, enet
, libopus
, vulkan-headers
, vulkan-utility-libraries
, vulkan-loader
, spirv-tools
, spirv-headers
, httplib
, cpp-jwt
, ffmpeg-headless
, libusb1
, cubeb
, sdl3
, discord-rpc
, gamemode
, qt6
, qt6Packages
, frozen
, xbyak
, xxhash
, simpleini
, vulkan-memory-allocator
}:

let
  cpmManifest = builtins.fromJSON (builtins.readFile "${src}/cpmfile.json");

  # Packages already provided by Nixpkgs buildInputs or unused on Linux x86_64
  systemOrIgnoredPackages = [
    "boost"
    "boost_headers"
    "catch2"
    "cpp-jwt"
    "cubeb"
    "discord-rpc"
    "enet"
    "ffmpeg"
    "fmt"
    "gamemode"
    "httplib"
    "lagoon"
    "libadrenotools"
    "libusb"
    "linkernsbypass"
    "llvm-mingw"
    "lz4"
    "moltenvk"
    "nlohmann"
    "oaknut"
    "openssl"
    "openssl-cmake"
    "quazip"
    "reshade"
    "sdl3"
    "simpleini"
    "spirv-headers"
    "streamline"
    "tzdb"
    "vulkan-headers"
    "vulkan-memory-allocator"
    "vulkan-utility-libraries"
    "vulkan-validation-layers"
    "xbyak"
    "zlib"
    "zstd"
  ];

  # Keep only the missing source-archive packages (biscuit, frozen, opus, sirit, zbic)
  bundledPackages = lib.filterAttrs
    (name: pkg:
      !(pkg.ci or false)
      && !(pkg ? artifact)
      && !(lib.elem name systemOrIgnoredPackages)
    )
    cpmManifest;

  # Fetch the raw .tar.gz with its exact sha512 and unpack it cleanly
  fetchAndUnpack = name: url: sha512:
    let
      tarball = fetchurl {
        name = "${name}.tar.gz";
        inherit url sha512;
      };
    in
    runCommand "${name}-source" { } ''
      mkdir -p $out
      tar -xzf ${tarball} -C $out --strip-components=1
    '';

  fetchedCpmSources = lib.mapAttrs
    (name: pkg:
      let
        host = pkg.git_host or "github.com";
      in
      fetchAndUnpack name "https://${host}/${pkg.repo}/archive/${pkg.version}.tar.gz" pkg.hash
    )
    bundledPackages;

  tzdbPkg = cpmManifest.tzdb;
  tzdb = fetchAndUnpack
    "tzdb"
    "https://${tzdbPkg.git_host}/${tzdbPkg.repo}/releases/download/${tzdbPkg.version}/${tzdbPkg.version}.tar.gz"
    tzdbPkg.hash;

  autoCpmFlags = lib.flatten (lib.mapAttrsToList
    (name: storePath: [
      "-D${name}_FORCE_BUNDLED=ON"
      "-D${name}_CUSTOM_DIR=${storePath}"
    ])
    fetchedCpmSources);
in
stdenv.mkDerivation {
  pname = "lichii";
  version = "git";
  inherit src;

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail 'set(zstd_FORCE_BUNDLED ON)' 'set(zstd_FORCE_SYSTEM ON)'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    git
    glslang
    unzip
    jq
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    openssl
    boost
    fmt_11
    nlohmann_json
    lz4
    zlib
    zstd
    enet
    libopus
    vulkan-headers
    vulkan-utility-libraries
    vulkan-loader
    spirv-tools
    spirv-headers
    httplib
    cpp-jwt
    ffmpeg-headless
    libusb1
    cubeb
    sdl3
    discord-rpc
    gamemode
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtwayland
    qt6.qtcharts
    qt6.qt5compat
    frozen
    xbyak
    xxhash
    simpleini
    vulkan-memory-allocator
    qt6Packages.quazip
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCPMUTIL_FORCE_SYSTEM=ON"
    "-DLICHII_USE_CPM=ON"
    "-DLICHII_USE_BUNDLED_FFMPEG=OFF"
    "-DLICHII_USE_BUNDLED_SDL3=OFF"
    "-DENABLE_RESHADE=OFF"
    "-DENABLE_WERROR=OFF"
    "-DYUZU_TESTS=OFF"
    "-DENABLE_UPDATE_CHECKER=OFF"
    "-Dnx_tzdb_FORCE_BUNDLED=ON"
    "-Dnx_tzdb_CUSTOM_DIR=${tzdb}"
    "-Dtzdb_FORCE_BUNDLED=ON"
    "-Dtzdb_CUSTOM_DIR=${tzdb}"
  ] ++ autoCpmFlags;
}
