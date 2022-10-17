load("@//:cdda_version.bzl", "CDDA_VERSION")

genrule(
    name = "cdda_version_gen",
    outs = ["version.h"],
    cmd = "echo '#define VERSION \"{}\"' > \"$@\"".format(CDDA_VERSION),
)

cc_library(
    name = "cdda_version",
    hdrs = [":cdda_version_gen"],
)

cc_library(
    name = "cdda",
    srcs = glob(
        [
            "src/**/*.cpp",
            "src/**/*.h",
            "src/**/*.hpp",
        ],
        exclude = ["src/**/main.cpp"],
    ),
    copts = ["-Iexternal/cdda/src"],
    deps = [":cdda_version", "@sdl2", "@sdl2_image", "@sdl2_ttf", "@sdl2_mixer"],
    includes = ["src", "src/third-party"],
    hdrs = glob(["src/**/*.h"]) + ["src/main.cpp"],
    defines = ["TILES", "SDL_SOUND", "LOCALIZE"],
    visibility = ["//visibility:public"],
)

exports_files(["data", "gfx"])
