const Terminal = @import("terminal.zig").Terminal;

pub inline fn setEsp(new_esp_value: usize) void {
    asm volatile (""
        :
        : [new_esp_value] "{esp}" (new_esp_value),
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

