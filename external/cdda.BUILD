load("@//:cdda_version.bzl", "CDDA_VERSION")

genrule(
    name = "cdda_version_gen",
    outs = ["version.h"],
    cmd = "echo '#define VERSION \"{}\"' > \"$@\"".format(CDDA_VERSION),
)

LANGS = [x.split('/')[-1].split('.')[0] for x in glob(["lang/po/*.po"])]

[
    genrule(
        name = "cdda_mo_" + lang,
        srcs = ["lang/po/{}.po".format(lang)],
        outs = ["lang/mo/{}/LC_MESSAGES/cataclysm-dda.mo".format(lang)],
        cmd = "msgfmt -f -o $@ $<",
    )
    for lang in LANGS]

filegroup(
    name = "cdda_mo",
    srcs = [":cdda_mo_{}".format(lang) for lang in LANGS],
    visibility = ["//visibility:public"],
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
