const std = @import("std");

const tcod = @import("ztcod");

pub const map_t = opaque {};
pub const dijkstra_t = opaque {};

pub const map_new = TCOD_map_new;
extern fn TCOD_map_new(width: usize, height: usize) *map_t;

pub const map_delete = TCOD_map_delete;
extern fn TCOD_map_delete(map: *map_t) void;

pub const map_set_properties = TCOD_map_set_properties;
extern fn TCOD_map_set_properties(map: *map_t, x: usize, y: usize, is_visible: bool, is_walkable: bool) void;

pub const map_is_walkable = TCOD_map_is_walkable;
extern fn TCOD_map_is_walkable(map: *map_t, x: usize, y: usize) bool;

pub const dijkstra_new = TCOD_dijkstra_new;
extern fn TCOD_dijkstra_new(map: *map_t, diagonal_cost: f32) *dijkstra_t;

pub const dijkstra_delete = TCOD_dijkstra_delete;
extern fn TCOD_dijkstra_delete(data: *dijkstra_t) void;

pub const dijkstra_compute = TCOD_dijkstra_compute;
extern fn TCOD_dijkstra_compute(data: *dijkstra_t, root_x: usize, root_y: usize) void;

pub const dijkstra_path_set = TCOD_dijkstra_path_set;
extern fn TCOD_dijkstra_path_set(data: *dijkstra_t, x: usize, y: usize) void;

pub const dijkstra_path_walk = TCOD_dijkstra_path_walk;
extern fn TCOD_dijkstra_path_walk(data: *dijkstra_t, x: *usize, y: *usize) bool;

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
