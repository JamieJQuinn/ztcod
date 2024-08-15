const std = @import("std");

pub fn build(b: *std.Build) !void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    _ = b.addModule("root", .{
        .root_source_file = b.path("src/ztcod.zig"),
    });

    const libtcod = b.addStaticLibrary(.{
        .name = "tcod",
        .target = target,
        .optimize = optimize,
    });
    libtcod.linkLibC();
    libtcod.addIncludePath(b.path("lib/libtcod/src"));
    libtcod.addIncludePath(b.path("lib/libtcod/src/vendor"));
    libtcod.addIncludePath(b.path("lib/libtcod/src/vendor/utf8proc"));
    var c_srcs = std.ArrayList([]const u8).init(b.allocator);
    try c_srcs.appendSlice(&.{ 
        "lib/libtcod/src/libtcod/bresenham_c.c",
        "lib/libtcod/src/libtcod/bsp_c.c",
        "lib/libtcod/src/libtcod/color.c",
        "lib/libtcod/src/libtcod/console.c",
        "lib/libtcod/src/libtcod/console_drawing.c",
        "lib/libtcod/src/libtcod/console_etc.c",
        "lib/libtcod/src/libtcod/console_init.c",
        "lib/libtcod/src/libtcod/console_printing.c",
        "lib/libtcod/src/libtcod/console_rexpaint.c",
        "lib/libtcod/src/libtcod/context.c",
        "lib/libtcod/src/libtcod/context_init.c",
        "lib/libtcod/src/libtcod/context_viewport.c",
        "lib/libtcod/src/libtcod/error.c",
        "lib/libtcod/src/libtcod/fov_c.c",
        "lib/libtcod/src/libtcod/fov_circular_raycasting.c",
        "lib/libtcod/src/libtcod/fov_diamond_raycasting.c",
        "lib/libtcod/src/libtcod/fov_permissive2.c",
        "lib/libtcod/src/libtcod/fov_recursive_shadowcasting.c",
        "lib/libtcod/src/libtcod/fov_restrictive.c",
        "lib/libtcod/src/libtcod/fov_symmetric_shadowcast.c",
        "lib/libtcod/src/libtcod/globals.c",
        "lib/libtcod/src/libtcod/heapq.c",
        "lib/libtcod/src/libtcod/heightmap_c.c",
        "lib/libtcod/src/libtcod/image_c.c",
        "lib/libtcod/src/libtcod/lex_c.c",
        "lib/libtcod/src/libtcod/list_c.c",
        "lib/libtcod/src/libtcod/logging.c",
        "lib/libtcod/src/libtcod/mersenne_c.c",
        "lib/libtcod/src/libtcod/namegen_c.c",
        "lib/libtcod/src/libtcod/noise_c.c",
        "lib/libtcod/src/libtcod/parser_c.c",
        "lib/libtcod/src/libtcod/path_c.c",
        "lib/libtcod/src/libtcod/pathfinder.c",
        "lib/libtcod/src/libtcod/pathfinder_frontier.c",
        "lib/libtcod/src/libtcod/random.c",
        "lib/libtcod/src/libtcod/renderer_sdl2.c",
        "lib/libtcod/src/libtcod/renderer_xterm.c",
        "lib/libtcod/src/libtcod/sys_c.c",
        "lib/libtcod/src/libtcod/sys_sdl_c.c",
        "lib/libtcod/src/libtcod/sys_sdl_img_bmp.c",
        "lib/libtcod/src/libtcod/sys_sdl_img_png.c",
        "lib/libtcod/src/libtcod/tileset_bdf.c",
        "lib/libtcod/src/libtcod/tileset.c",
        "lib/libtcod/src/libtcod/tileset_fallback.c",
        "lib/libtcod/src/libtcod/tileset_render.c",
        "lib/libtcod/src/libtcod/tileset_truetype.c",
        "lib/libtcod/src/libtcod/tree_c.c",
        "lib/libtcod/src/libtcod/txtfield_c.c",
        "lib/libtcod/src/libtcod/wrappers.c",
        "lib/libtcod/src/libtcod/zip_c.c",
        "lib/libtcod/src/vendor/stb.c",
        "lib/libtcod/src/vendor/lodepng.c",
    });
    for(c_srcs.items) |src| {
        libtcod.addCSourceFile(.{
            .file = b.path(src),
            .flags = &.{ "-fno-sanitize=undefined", "-DNO_SDL=1", "-Wdeprecated-declarations" },
        });
    }
    b.installArtifact(libtcod);

    const test_step = b.step("test", "Run tests");

    const tests = b.addTest(.{
        .name = "ztcod-tests",
        .root_source_file = b.path("src/ztcod.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(tests);

    tests.addIncludePath(b.path("lib/libtcod/src"));
    tests.linkLibrary(libtcod);

    test_step.dependOn(&b.addRunArtifact(tests).step);
}
