comptime {
    asm (
        \\.type loadGDT, @function
        \\.global loadGDT
        \\loadGDT:
        \\  mov +4(%esp), %eax
        \\  lgdt (%eax)
        \\
        \\  mov $0x10, %ax
        \\  mov %ax, %ds
        \\  mov %ax, %es
        \\  mov %ax, %fs
        \\  mov %ax, %gs
        \\  mov %ax, %ss
        \\
        \\  ljmp $0x08, $1f
        \\  1: ret
    );
}
extern fn loadGDT(gdtr: *const GDTRegister) void;

// Access byte values.
const KERNEL = 0x90;
const USER = 0xF0;
const CODE = 0x0A;
const DATA = 0x02;

// Segment flags.
const PROTECTED = (1 << 2);
const BLOCKS_4K = (1 << 3);

const GDTEntry = packed struct {
    limit_low: u16,
    base_low: u16,
    base_mid: u8,
    access: u8,
    limit_high: u4,
    flags: u4,
    base_high: u8,
};

const GDTRegister = packed struct {
    limit: u16,
    base: *const GDTEntry,
};

fn makeEntry(comptime base: usize, comptime limit: usize, comptime access: u8, comptime flags: u4) GDTEntry {
    comptime {
        return GDTEntry{
            .limit_low = @truncate(u16, limit),
            .base_low = @truncate(u16, base),
            .base_mid = @truncate(u8, base >> 16),
            .access = @truncate(u8, access),
            .limit_high = @truncate(u4, limit >> 16),
            .flags = @truncate(u4, flags),
            .base_high = @truncate(u8, base >> 24),
        };
    }
}

var gdt align(4) = [_]GDTEntry{
    makeEntry(0, 0, 0, 0),
    makeEntry(0, 0xFFFFF, KERNEL | CODE, PROTECTED | BLOCKS_4K),
    makeEntry(0, 0xFFFFF, KERNEL | DATA, PROTECTED | BLOCKS_4K),
};

var gdtr = GDTRegister{
    .limit = @as(u16, @sizeOf(@TypeOf(gdt)) - 1),
    .base = undefined,
};

pub fn initialize() void {
    gdtr.base = &gdt[0];
    loadGDT(&gdtr);
}
