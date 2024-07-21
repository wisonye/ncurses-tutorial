const std = @import("std");

//
//
//
pub fn create_ncurses_example_binary(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    name: []const u8,
    source_file: []const u8,
) *std.Build.Step.Compile {
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = b.path(source_file),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    exe.linkSystemLibrary("ncursesw");

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    var step_name_buffer: [128]u8 = undefined;
    const run_step_name = std.fmt.bufPrint(
        &step_name_buffer,
        "run-{s}",
        .{name},
    ) catch "";

    var step_desc_buffer: [128]u8 = undefined;
    const run_step_desc = std.fmt.bufPrint(
        &step_desc_buffer,
        "Run {s}",
        .{name},
    ) catch "";

    const run_step = b.step(run_step_name, run_step_desc);
    run_step.dependOn(&run_cmd.step);

    return exe;
}
