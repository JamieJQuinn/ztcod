# ztcod - Build package and bindings for [libtcod](https://github.com/libtcod/libtcod)

## Caveats

To limit dependencies, SDL and OpenGL are disabled so some features of libtcod will not work. Since I am only using features of libtcod that do not require SDL and OpenGL such as the noise and FOV algorithms, I will not get these dependencies working but I'm happy to review a PR adding them back in. 

I haven't tested many libtcod functions from Zig so cannot guarantee all bindings are currently working. Since libtcod is a large library, I suspect some features will be broken in Zig without further porting work.

## Getting started

1. Fetch ztcod (replace <version> with desired version) and save to your dependencies:
```bash
zig fetch --save=ztcod git+https://github.com/jamiejquinn/ztcod#<version>
```
or for the latest `main`:
```bash
zig fetch --save=ztcod git+https://github.com/jamiejquinn/ztcod#main
```

2. Add to your `build.zig`:

```zig
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{ ... });

    const ztcod = b.dependency("ztcod", .{});
    exe.root_module.addImport("ctcod", ztcod.module("root"));
    exe.linkLibrary(ztcod.artifact("tcod"));
}
```
