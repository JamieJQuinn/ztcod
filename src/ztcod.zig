const std = @import("std");

pub const c = @import("c_translate_tcod");

test "Running tcod functions" {
    const nx = 16;
    const ny = 16;

    const map = c.TCOD_map_new(nx, ny);
    defer c.TCOD_map_delete(map);

    c.TCOD_map_clear(map, true, true);

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
            const idx = (nx+1)*j+i;
            const x: c_int = @intCast(i);
            const y: c_int = @intCast(j);
            if(strmap[idx] == '.') {
                c.TCOD_map_set_properties(map, x, y, true, true);
            } else if(strmap[idx] == '#') {
                c.TCOD_map_set_properties(map, x, y, false, false);
            } else if(strmap[idx] == '@') {
                player_x = x;
                player_y = y;
            }
        }
    }

    _ = c.TCOD_map_compute_fov(map, @intCast(player_x), @intCast(player_y), 12, true, c.FOV_SYMMETRIC_SHADOWCAST);

    for(0..ny) |j| {
        for(0..nx) |i| {
            const x: c_int = @intCast(i);
            const y: c_int = @intCast(j);
            if(c.TCOD_map_is_in_fov(map, x, y)) {
                std.debug.print("{c}", .{strmap[(nx+1)*j + i]});
            } else {
                std.debug.print(" ", .{});
            }
        }
        std.debug.print("\n", .{});
    }
}
