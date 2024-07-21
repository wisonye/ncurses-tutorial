const std = @import("std");
const nc = @import("nc.zig");

const ENABLE_KEY_DEBUG_MODE: bool = true;
// const ENABLE_KEY_DEBUG_MODE: bool = false;

//
//
//
fn update_cursor_position(win: ?*nc.WINDOW, row: c_int, col: c_int) void {
    _ = nc.mvwprintw(
        win,
        1,
        2,
        "Cursor pos: (%d, %d)",
        col,
        row,
    );
    _ = nc.wrefresh(win);
}

//
//
//
pub fn main() void {
    //
    // Enable UTF8 support
    //
    _ = nc.setlocale(nc.LC_ALL, null);

    //
    // Init screen
    //
    _ = nc.initscr();
    defer _ = nc.endwin();

    // //
    // // Check and enable color support
    // //
    // if (!nc.has_colors() || !nc.can_change_color()) {
    // 	fmt::printfln(">>> Terminal doesn't support colors")!;
    // 	return -1;
    // };
    // nc.start_color();

    //
    // Hide cursor
    //
    // nc.hide_cursor();

    //
    // Input options
    //
    _ = nc.cbreak();
    _ = nc.noecho();
    _ = nc.nonl();
    _ = nc.raw();

    //
    // Create typing window and print something
    //
    const term_size = nc.get_window_size(nc.stdscr);
    const typing_window_height = term_size.height - 3;
    const typing_window = nc.newwin(typing_window_height, term_size.width, 0, 0);
    defer _ = nc.delwin(typing_window);
    _ = nc.wrefresh(nc.stdscr);

    // _ = nc.box(typing_window, 0, 0);

    const start_col = 2;
    var row: c_int = 0;

    _ = nc.mvwprintw(
        typing_window,
        row,
        start_col,
        if (ENABLE_KEY_DEBUG_MODE) "[ Editor typing example - Key debug mode: enabled ]" else "[ Editor typing example ]",
    );

    row += 2;
    _ = nc.mvwprintw(
        typing_window,
        row,
        start_col,
        "Try typing right now, press 'Q' to exit:)",
    );
    row += 2;
    _ = nc.wmove(typing_window, row, start_col);
    _ = nc.wrefresh(typing_window);

    //
    // Create status window and print typing window cursor position
    //
    const status_window_height = 3;
    const status_window = nc.newwin(status_window_height, term_size.width, typing_window_height, 0);
    defer _ = nc.delwin(status_window);

    _ = nc.wrefresh(nc.stdscr);

    // _ = nc.box(status_window, 0, 0);

    var pos = nc.get_cursor_position(typing_window);
    _ = update_cursor_position(status_window, pos.y, pos.x);

    //
    // Typing loop
    //
    var c: c_int = nc.wgetch(typing_window);
    while (true) {
        //
        // Print key debug info to status window (fixed on bottom right area)
        //
        if (ENABLE_KEY_DEBUG_MODE) {
            var debug_buffer: [30]u8 = [_]u8{0x00} ** 30;
            _ = std.fmt.bufPrint(
                &debug_buffer,
                "Key: 0x{X:0>2} ({}) - {?s}",
                .{
                    c,
                    c,
                    nc.keyname(c),
                },
            ) catch "";

            _ = nc.mvwprintw(
                status_window,
                1,
                term_size.width - 30,
                "%20s",
                @as([*]const u8, @ptrCast(&debug_buffer)),
            );
            _ = nc.wrefresh(status_window);
        }

        _ = switch (c) {
            'Q' => break,
            nc.KEY_ESCAPE => {},
            nc.KEY_DEL => {
                pos = nc.get_cursor_position(typing_window);
                if (pos.y != 0 and pos.x != 0) {
                    _ = nc.mvwdelch(nc.stdscr, pos.y, pos.x - 1);
                }
            },
            nc.KEY_CTRL_A => {},
            nc.KEY_CTRL_B => {},
            nc.KEY_CTRL_C => {},
            nc.KEY_CTRL_D => {},
            nc.KEY_CTRL_E => {},
            nc.KEY_CTRL_F => {},
            nc.KEY_CTRL_G => {},
            nc.KEY_CTRL_H => {},
            // nc.KEY_CTRL_I => void; // ^I -> TAB
            nc.KEY_CTRL_J => {},
            nc.KEY_CTRL_K => {},
            nc.KEY_CTRL_L => {},
            // nc.KEY_CTRL_M => void; // ^M -> CR
            nc.KEY_CTRL_N => {},
            nc.KEY_CTRL_O => {},
            nc.KEY_CTRL_P => {},
            nc.KEY_CTRL_Q => {},
            nc.KEY_CTRL_R => {},
            nc.KEY_CTRL_S => {},
            nc.KEY_CTRL_T => {},
            nc.KEY_CTRL_U => {},
            nc.KEY_CTRL_V => {},
            nc.KEY_CTRL_W => {},
            nc.KEY_CTRL_X => {},
            nc.KEY_CTRL_Y => {},
            nc.KEY_CTRL_Z => {},

            nc.KEY_CR => {
                //
                // Manually add new line character, as `nonl`
                // disable `\n` translation.
                //
                _ = nc.waddch(typing_window, '\n');

                //
                // Fix new line start typing position
                //
                pos = nc.get_cursor_position(typing_window);
                _ = nc.wmove(typing_window, pos.y, start_col);
            },
            nc.KEY_TAB => {
                //
                // Manually add tab character
                //
                _ = nc.waddch(typing_window, '\t');
            },
            //
            // Default: Print the pressed key
            //
            else => nc.wprintw(typing_window, "%s", nc.keyname(c)),
        };
        _ = nc.wrefresh(typing_window);

        //
        //
        //
        pos = nc.get_cursor_position(typing_window);
        _ = update_cursor_position(status_window, pos.y, pos.x);

        c = nc.wgetch(typing_window);
    }
}
