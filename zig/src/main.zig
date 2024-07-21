const std = @import("std");
const print = std.debug.print;
const nc = @import("nc.zig");

pub fn main() !void {
    //
    // Enable UTF8 support
    //
    _ = nc.setlocale(nc.LC_ALL, null);

    //
    // Init screen
    //
    _ = nc.initscr();
    // defer nc.endwin();

    // //
    // // Check and enable color support
    // //
    // if (!nc.has_colors() || !nc.can_change_color()) {
    //     print("\n>>> Terminal doesn't support colors", .{});
    //     return -1;
    // }
    // nc.start_color();

    //
    // Hide cursor
    //
    _ = nc.hide_cursor();

    // //
    // // Print tile and exit tips
    // //
    // const term_size = nc.get_window_size(nc.stdscr);
    // nc.mvwprintw(nc.stdscr, 0, 1, @as(
    //     [*]const u8,
    //     @ptrCast("[ Window border example ]"),
    // ));
    // nc.mvwprintw(
    //     nc.stdscr,
    //     term_size.height - 2,
    //     1,
    //     @as([*]const u8, @ptrCast("Press any key to exit:)")),
    // );

    _ = nc.mvwprintw(
        nc.stdscr,
        0,
        1,
        @as([*]const u8, @ptrCast("[ Window border example ]")),
    );
    _ = nc.mvwprintw(
        nc.stdscr,
        1,
        1,
        "[ Window border example ]",
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
