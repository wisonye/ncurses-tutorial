const std = @import("std");
const print = std.debug.print;
const nc = @import("nc.zig");

pub fn main() !void {
    //
    // Enable UTF8 support
    //
    const result = nc.setlocale(nc.LC_ALL, "en_US.UTF-8");

    //
    // Init screen
    //
    _ = nc.initscr();
    defer _ = nc.endwin();

    //
    // Check and enable color support
    //
    if (!nc.has_colors() or !nc.can_change_color()) {
        print("\n>>> Terminal doesn't support colors", .{});
        return;
    }
    _ = nc.start_color();

    //
    // Hide cursor
    //
    _ = nc.hide_cursor();

    //
    // Print something
    //
    _ = nc.mvwprintw(
        nc.stdscr,
        1,
        0,
        "[ UTF8 test ]\n>>> setlocale result: %s",
        result,
    );
    _ = nc.mvwprintw(
        nc.stdscr,
        3,
        0,
        ">>> UTF8 icons: %s",
        "⚡          ",
    );
    _ = nc.wrefresh(nc.stdscr);

    _ = nc.wgetch(nc.stdscr);

    return;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
