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
    deps = [":zip_c"],
    module_map = "Zip/minizip/module/module.modulemap",
    module_name = "Minizip",
)

swift_library(
    name = "zip",
    module_name = "Zip",
    srcs = glob([
        "Zip/*.swift",
    ]),
    visibility = ["//visibility:public"],
    deps = [":zip_c_mod"],
)
