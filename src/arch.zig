const builtin = @import("builtin");
pub usingnamespace switch (builtin.cpu.arch) {
    .x86 => @import("arch/x86/arch.zig"),
    else => @compileError("Architechture not supported!"),
};
