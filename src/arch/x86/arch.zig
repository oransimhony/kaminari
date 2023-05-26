const gdt = @import("gdt.zig");

pub inline fn setStackPointer(new_stack_pointer_value: usize) void {
    asm volatile (""
        :
        : [new_stack_pointer_value] "{esp}" (new_stack_pointer_value),
    );
}

pub inline fn clearInterrupts() void {
    asm volatile ("cli");
}

pub inline fn setInterrupts() void {
    asm volatile ("sti");
}

pub inline fn halt() void {
    asm volatile ("hlt");
}

pub fn initialize() void {
    gdt.initialize();
}
