load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@build_bazel_rules_apple//apple:versioning.bzl", "apple_bundle_version")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

apple_bundle_version(
    name = "version",
    build_version = "1.0.134",
    short_version_string = "1.0",
)

filegroup(
    name = "common_bundle_assets",
    srcs = glob(["Common/Bundle/Assets.xcassets/**"], exclude = ["**/.DS_Store"]),
)

swift_library(
    name = "cdda_swift_common",
    srcs = [
        "Common/source/PageUpDownPanGestureRecognizer.swift",
        "Common/source/MenuButton.swift",
        "Common/source/ZipArchiver.swift",
        "Common/source/ShowAndFixGestureRecognizer.swift",
    ],
    deps = ["@zip"],
    data = [
        "Common/Bundle/Base.lproj/UIControls.storyboard",
        ":common_bundle_assets",
    ],
    generates_header = True,
    generated_header_name = "CDDA-Swift.h",
)

objc_library(
    name = "cdda_objc_common_gamepad",
    srcs = [
        "Common/source/SDL_uikitviewcontroller+Gamepad.mm",
        "Common/source/SDL_uikitviewcontroller+Gamepad.h",
        "Common/source/GamePadViewController.h",
        "Common/source/game_dependent.mm",
        "Common/source/game_dependent.h",
    ],
    hdrs = [
        "Common/source/SDL_char_utils.h",
    ],
    copts = ["-std=c++14"],
    deps = ["@cdda", "@sdl2", ":cdda_swift_common"],
)

objc_library(
    name = "cdda_objc_common",
    srcs = [
        "Common/source/GamePadViewController.h",
        "Common/source/AppDelegate.h",
        "Common/source/SDL_char_utils.m",
        "Common/source/SDL_uikitviewcontroller+KeyboardKeysHandling.m",
        "Common/source/SDL_uikitview+CDDA.m",
        "Common/source/SDL_uikitviewcontroller+VirtualKeyboardInput.h",
        "Common/source/path_utils.h",
        "Common/source/GamePadViewController.m",
        "Common/source/main.m",
        "Common/source/CDDA-Bridging-Header.h",
        "Common/source/SDL_uikitviewcontroller+KeyboardKeysHandling.h",
        "Common/source/SDL_char_utils.h",
        "Common/source/CDDA_iOS_main.h",
        "Common/source/AppDelegate.m",
        "Common/source/SDL_uikitviewcontroller+VirtualKeyboardInput.m",
        "Common/source/SDL_uikitview+CDDA.h",
        "Common/source/path_utils.m",
    ],
    includes = ["Common/source"],
    deps = ["@sdl2", "@jscontroller", ":cdda_swift_common", ":cdda_objc_common_gamepad"],
    data = [
        "Common/Bundle/Base.lproj/Main.storyboard",
        "Common/Bundle/JSDPad/dPad-None@2x.png",
        "Common/Bundle/Settings.bundle",
    ],
)

objc_library(
    name = "cdda_objc_distinct",
    srcs = [
        "Distinct/source/MainViewController.m",
    ],
    hdrs = [
        "Distinct/source/MainViewController.h",
    ],
    deps = [":cdda_swift_common", ":cdda_objc_common"],
    data = [
        "Distinct/icon_1024x1024.png",
    ],
)

objc_library(
    name = "cdda_ios_main",
    srcs = [
        "Distinct/source/CDDA_iOS_main.mm",
    ],
    hdrs = [
        "Common/source/CDDA_iOS_main.h",
    ],
    copts = ["-std=gnu++14"],
    deps = ["@cdda", "@sdl2", ":cdda_objc_distinct"],
    data = [
        "@cdda//:data",
        "@cdda//:gfx",
    ] + glob(["Common/Bundle/*.lproj/**"], exclude = ["Common/Bundle/Base.lproj/**"]),
)

filegroup(
    name = "app_icon",
    srcs = glob(["Distinct/Assets.xcassets/**"], exclude = ["**/.DS_Store"]),
)

ios_application(
    name = "cdda_ios",
    bundle_id = "net.nornagon.CDDA-Experimental",
    families = [
        "iphone",
        "ipad",
    ],
    minimum_os_version = "11.0",
    infoplists = [":Distinct/CDDA.plist"],
    version = ":version",
    visibility = ["//visibility:public"],
    launch_storyboard = "Common/Bundle/Base.lproj/LaunchScreen.storyboard",
    deps = ["@cdda", ":cdda_objc_common", ":cdda_objc_distinct", ":cdda_ios_main"],
    app_icons = [":app_icon"],
    provisioning_profile = "9a4c6de6-ccee-4064-a5cd-1133f9dac8c7.mobileprovision",
)
