objc_library(
  name = "sdl2_image_objc",
  srcs = [
    "SDL_image.h",
  ],
  non_arc_srcs = [
    "IMG_ImageIO.m",
  ],
  deps = [
    "@sdl2",
  ],
  copts = ["-DPNG_USES_IMAGEIO"],
  sdk_frameworks = [
    "CoreServices",
  ]
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
  visibility = ["//visibility:public"],
  local_defines = ["PNG_USES_IMAGEIO"],
  deps = [
    "@sdl2",
    ":sdl2_image_objc",
  ],
  include_prefix = "",
)
