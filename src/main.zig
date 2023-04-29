const std = @import("std");
const builtin = @import("builtin");
const Terminal = @import("terminal.zig").Terminal;

pub fn kmain() void {
    const entry_message = std.fmt.comptimePrint("Hello World from Zig {s}\n", .{builtin.zig_version_string});
    Terminal.initialize();
    Terminal.write(entry_message);
}
