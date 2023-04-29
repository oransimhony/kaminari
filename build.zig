const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "kaminari",
        .root_source_file = .{ .path = "src/boot.zig" },
        .target = .{ .cpu_arch = .x86, .os_tag = .freestanding, .abi = .none },
        .optimize = .ReleaseFast,
        .linkage = .static,
    });

    exe.setLinkerScriptPath(.{ .path = "linker.ld" });

    b.installArtifact(exe);

    const qemu_cmd = b.addSystemCommand(&.{
        "qemu-system-i386",
        "-kernel",
    });
    qemu_cmd.addArtifactArg(exe);

    qemu_cmd.step.dependOn(b.getInstallStep());

    const qemu_step = b.step("run", "Run the kernel in qemu");
    qemu_step.dependOn(&qemu_cmd.step);
}
