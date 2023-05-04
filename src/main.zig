const std = @import("std");
const builtin = @import("builtin");
const Terminal = @import("terminal.zig").Terminal;

pub fn kmain() void {
    Terminal.initialize();
    printInitMessage();
    while (true) {}
}

fn printInitMessage() void {
    Terminal.printf("Hello World from Zig {s}\n", .{builtin.zig_version_string});
}
