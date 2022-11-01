load("@build_bazel_rules_swift//swift:swift.bzl", "swift_c_module", "swift_library")

cc_library(
    name = "zip_c",
    srcs = glob([
        "Zip/*.h",
        "Zip/minizip/**/*.c",
        "Zip/minizip/**/*.h",
    ]),
    includes = ["Zip/minizip/include"],
)

swift_c_module(
    name = "zip_c_mod",
    module_map = "Zip/minizip/module/module.modulemap",
    module_name = "Minizip",
    deps = [":zip_c"],
)

swift_library(
    name = "zip",
    srcs = glob([
        "Zip/*.swift",
    ]),
    module_name = "Zip",
    visibility = ["//visibility:public"],
    deps = [":zip_c_mod"],
)
