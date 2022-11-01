objc_library(
    name = "sdl2_image_objc",
    srcs = [
        "SDL_image.h",
    ],
    copts = ["-DPNG_USES_IMAGEIO"],
    non_arc_srcs = [
        "IMG_ImageIO.m",
    ],
    sdk_frameworks = [
        "CoreServices",
    ],
    deps = [
        "@sdl2",
    ],
)

cc_library(
    name = "sdl2_image",
    srcs = [
        "IMG.c",
        "IMG_WIC.c",
        "IMG_avif.c",
        "IMG_bmp.c",
        "IMG_gif.c",
        "IMG_jpg.c",
        "IMG_jxl.c",
        "IMG_lbm.c",
        "IMG_pcx.c",
        "IMG_pnm.c",
        "IMG_qoi.c",
        "IMG_stb.c",
        "IMG_svg.c",
        "IMG_tga.c",
        "IMG_tif.c",
        "IMG_webp.c",
        "IMG_xcf.c",
        "IMG_xpm.c",
        "IMG_xv.c",
        "IMG_xxx.c",
    ],
    hdrs = glob(["*.h"]),
    include_prefix = "",
    local_defines = ["PNG_USES_IMAGEIO"],
    visibility = ["//visibility:public"],
    deps = [
        ":sdl2_image_objc",
        "@sdl2",
    ],
)
