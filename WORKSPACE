load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

git_repository(
    name = "build_bazel_rules_apple",
    remote = "https://github.com/bazelbuild/rules_apple.git",
    tag = "1.1.2",
)


http_archive(
    name = "build_bazel_rules_swift",
    sha256 = "51efdaf85e04e51174de76ef563f255451d5a5cd24c61ad902feeadafc7046d9",
    url = "https://github.com/bazelbuild/rules_swift/releases/download/1.2.0/rules_swift.1.2.0.tar.gz",
)

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()


git_repository(
    name = "build_bazel_apple_support",
    remote = "https://github.com/bazelbuild/apple_support.git",
    tag = "1.3.1",
)

git_repository(
    name = "bazel_skylib",
    remote = "https://github.com/bazelbuild/bazel-skylib.git",
    tag = "1.3.0",
)

http_archive(
    name = "bazelregistry_sdl2",
    strip_prefix = "sdl2-c3efa24f546f0d8be97aaf1609688905e585cd69",
    urls = ["https://github.com/bazelregistry/sdl2/archive/c3efa24f546f0d8be97aaf1609688905e585cd69.zip"],
    sha256 = "735b86e808d78c3a6e7db86c4532140be4ad5d7349feea2dbfef7ea1382c31eb",
)

http_archive(
    name = "sdl2",
    build_file = "sdl2.BUILD",
    sha256 = "56a6489dba5fe2d951721c95913b630ff308c54393a2e20609ae8a8445354ef4",
    strip_prefix = "SDL-release-2.0.14",
    urls = ["https://github.com/libsdl-org/SDL/archive/refs/tags/release-2.0.14.zip"],
)

http_archive(
  name = "sdl2_image",
  build_file = "sdl2_image.BUILD",
  urls = ["https://github.com/libsdl-org/SDL_image/archive/refs/tags/release-2.6.2.zip"],
  sha256 = "98d9c4e1de93e8ae12669e44176cf45217d8148c96d40ffd785768ab953d0c89",
  strip_prefix = "SDL_image-release-2.6.2",
)

http_archive(
    name = "sdl2_ttf",
    build_file = "sdl2_ttf.BUILD",
    sha256 = "ad7a7d2562c19ad2b71fa4ab2e76f9f52b3ee98096c0a7d7efbafc2617073c27",
    strip_prefix = "SDL2_ttf-2.0.14",
    urls = ["https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.zip"],
)

http_archive(
    name = "sdl2_mixer",
    build_file = "sdl2_mixer.BUILD",
    sha256 = "e92ddea6042e32789f7227bf2735409e3943612f19fd31ed338f3681881fe8a1",
    strip_prefix = "SDL_mixer-release-2.6.2",
    urls = ["https://github.com/libsdl-org/SDL_mixer/archive/refs/tags/release-2.6.2.zip"],
)

http_archive(
    name = "freetype",
    build_file = "freetype.BUILD",
    # We patch out some modules we don't use from freetype config file.
    patch_args = ["-p1"],
    patches = ["freetype_config.patch"],
    sha256 = "bf380e4d7c4f3b5b1c1a7b2bf3abb967bda5e9ab480d0df656e0e08c5019c5e6",
    strip_prefix = "freetype-2.9",
    urls = ["https://download.savannah.gnu.org/releases/freetype/freetype-2.9.tar.gz"],
)

http_archive(
  name = "zip",
  build_file = "zip.BUILD",
  sha256 = "6c95dba09199e0a640442bdb4cc94d8ec0846234b3083d9c7c33795454dda8c9",
  strip_prefix = "Zip-2.1.2",
  urls = ["https://github.com/marmelroy/Zip/archive/refs/tags/2.1.2.zip"],
)
