cc_library(
  name = "libpng",
  srcs = glob([
    "*.h",
    "arm/*.h",
    "arm/*.c",
  ]) + [
    "png.c",
    "pngerror.c",
    "pngget.c",
    "pngmem.c",
    "pngpread.c",
    "pngread.c",
    "pngrio.c",
    "pngrtran.c",
    "pngrutil.c",
    "pngset.c",
    "pngtrans.c",
    "pngwio.c",
    "pngwrite.c",
    "pngwtran.c",
    "pngwutil.c",
  ],
  hdrs = glob(["*.h"]),
  visibility = ["//visibility:public"],
)