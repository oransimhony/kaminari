pub inline fn setEsp(new_esp_value: usize) void {
    asm volatile (""
        :
        : [new_esp_value] "{esp}" (new_esp_value),
    );
}

pub inline fn clearInterrupts() void {
    asm volatile ("cli");
}
