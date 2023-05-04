const kmain = @import("main.zig").kmain;
const arch = @import("arch.zig");

const Multiboot = extern struct {
    magic: c_long,
    flags: c_long,
    checksum: c_long,
};

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

export var multiboot align(4) linksection(".multiboot") = Multiboot{
    .magic = MAGIC,
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

export var stack_bytes: [16 * 1024]u8 align(4) linksection(".bss") = undefined;

export fn _start() callconv(.Naked) noreturn {
    arch.setEsp(@ptrToInt(&stack_bytes) + stack_bytes.len);

    kmain();

    arch.clearInterrupts();
    while (true) {
        arch.halt();
    }
}
