const std = @import("std");

const tcod = @cImport({
    @cInclude("libtcod.h");
});

pub usingnamespace tcod;

test "Running tcod functions" {
    const nx = 16;
    const ny = 16;

    const map = tcod.TCOD_map_new(nx, ny);
    defer tcod.TCOD_map_delete(map);

    tcod.TCOD_map_clear(map, true, true);

    const strmap = 
        \\................
        \\................
        \\................
        \\..##.....#......
        \\..#.....#.....#.
        \\.......#........
        \\.......#........
        \\......@.........
        \\.......#........
        \\.......#........
        \\.......#......#.
        \\.......#........
        \\................
        \\................
        \\................
        \\................
        ;

    var player_x: c_int = undefined;
    var player_y: c_int = undefined;

    for(0..ny) |j| {
        for(0..nx) |i| {
            const x: c_int = @intCast(i);
            const y: c_int = @intCast(j);
            const idx = (nx+1)*j+i;
            if(strmap[idx] == '.') {
                tcod.TCOD_map_set_properties(map, x, y, true, true);
            } else if(strmap[idx] == '#') {
                tcod.TCOD_map_set_properties(map, x, y, false, false);
            } else if(strmap[idx] == '@') {
                player_x = x;
                player_y = y;
            }
        }
    }

    _ = tcod.TCOD_map_compute_fov(map, player_x, player_y, 12, true, tcod.FOV_SYMMETRIC_SHADOWCAST);

    for(0..ny) |j| {
        for(0..nx) |i| {
            const x: c_int = @intCast(i);
            const y: c_int = @intCast(j);
            if(tcod.TCOD_map_is_in_fov(map, x, y)) {
                std.debug.print("{c}", .{strmap[(nx+1)*j + i]});
            } else {
                std.debug.print(" ", .{});
            }
        }
        std.debug.print("\n", .{});
    }
}
