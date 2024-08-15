const std = @import("std");

const tcod = @cImport({
    @cInclude("libtcod.h");
});

test "Running tcod functions" {
    const nx = 16;
    const ny = 16;

    const map = tcod.TCOD_map_new(nx, ny);
    defer tcod.TCOD_map_delete(map);

    tcod.TCOD_map_clear(map, true, true);

    tcod.TCOD_map_set_properties(map, 6, 5, false, true);

    _ = tcod.TCOD_map_compute_fov(map, 8, 8, 12, true, tcod.FOV_SYMMETRIC_SHADOWCAST);

    for(0..ny) |j| {
        for(0..nx) |i| {
            const x: c_int = @intCast(i);
            const y: c_int = @intCast(j);
            if(tcod.TCOD_map_is_in_fov(map, x, y)) {
                std.debug.print(".", .{});
            } else {
                std.debug.print(" ", .{});
            }
        }
        std.debug.print("\n", .{});
    }
}
