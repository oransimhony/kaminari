const std = @import("std");

pub const VgaColor = u8;
/// Hardware text mode color constants
pub const VgaColors = enum(VgaColor) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    LightBrown = 14,
    White = 15,
};

const VGA_HEIGHT = 25;
const VGA_WIDTH = 80;
var printf_buf: [256]u8 = undefined;

pub fn vgaEntryColor(fg: VgaColors, bg: VgaColors) VgaColor {
    return @enumToInt(fg) | (@enumToInt(bg) << 4);
}

fn vgaEntry(char: u8, color: VgaColor) u16 {
    return char | (@as(u16, color) << 8);
}

pub const Terminal = struct {
    var row: u8 = 0;
    var column: u8 = 0;

    var color = vgaEntryColor(VgaColors.LightGreen, VgaColors.Black);

    const buffer = @intToPtr([*]volatile u16, 0xB8000);

    pub fn initialize() void {
        clear();
    }

    pub fn clear() void {
        for (0..VGA_WIDTH) |c| {
            for (0..VGA_HEIGHT) |r| {
                putCharAt(' ', color, c, r);
            }
        }
    }

    pub fn setColor(newColor: VgaColor) void {
        color = newColor;
    }

    pub fn putCharAt(char: u8, char_color: VgaColor, x: usize, y: usize) void {
        const index = y * VGA_WIDTH + x;
        buffer[index] = vgaEntry(char, char_color);
    }

    pub fn putChar(char: u8) void {
        putCharAt(char, color, column, row);
        column += 1;
        if (column == VGA_WIDTH) {
            newline();
        }
    }

    fn newline() void {
        column = 0;
        row += 1;

        if (row == VGA_HEIGHT) {
            scrollback();
        }
    }

    fn scrollback() void {
        for (0..row) |r| {
            for (0..VGA_WIDTH) |c| {
                const index = r * VGA_WIDTH + c;
                const next_index = index + VGA_WIDTH;
                buffer[index] = buffer[next_index];
            }
        }

        for (0..VGA_WIDTH) |c| {
            const index = VGA_HEIGHT * VGA_WIDTH + c;
            buffer[index] = vgaEntry(' ', color);
        }
        row = VGA_HEIGHT - 1;
    }

    pub fn write(str: []const u8) void {
        for (str) |c| {
            if (c == '\n') {
                newline();
            } else {
                putChar(c);
            }
        }
    }

    pub fn print(comptime format: []const u8, args: anytype) void {
        _ = writer.print(format, args) catch unreachable;
    }

    pub const writer = std.io.Writer(void, error{}, callback){ .context = {} };

    fn callback(_: void, string: []const u8) error{}!usize {
        Terminal.write(string);
        return string.len;
    }
};
