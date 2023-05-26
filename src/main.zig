const std = @import("std");
const builtin = @import("builtin");
const Terminal = @import("terminal.zig").Terminal;
const arch = @import("arch.zig");

pub fn kmain() void {
    arch.initialize();
    Terminal.initialize();
    printInitMessage();
    while (true) {}
}

fn printInitMessage() void {
    Terminal.print("Hello World from Zig {s}\n", .{builtin.zig_version_string});
}
