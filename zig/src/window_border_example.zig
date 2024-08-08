const std = @import("std");
const nc = @import("nc.zig");
const print = std.debug.print;

pub fn main() void {
    //
    // Enable UTF8 support
    //
    _ = nc.setlocale(nc.LC_ALL, "en_US.UTF-8");

    //
    // Init screen
    //
    _ = nc.initscr();
    defer _ = nc.endwin();

    //
    // Check and enable color support
    //
    if (!nc.has_colors() or !nc.can_change_color()) {
        print(">>> Terminal doesn't support colors", .{});
        return;
    }
    _ = nc.start_color();

    //
    // Hide cursor
    //
    _ = nc.hide_cursor();

    //
    // Print tile and exit tips
    //
    const term_size = nc.get_window_size(nc.stdscr);
    _ = nc.mvwprintw(nc.stdscr, 0, 1, "[ Window border example ]");
    _ = nc.mvwprintw(nc.stdscr, term_size.height - 2, 1, "Press any key to exit:)");
    _ = nc.wrefresh(nc.stdscr);

    const win_width: c_int = 40;
    const win_height: c_int = 3;
    const win_left: c_int = 2;
    const y_padding: c_int = 1;
    var win_top: c_int = 2;

    //
    // Draw a few border windows
    //
    const regular_border_window = create_border_window(
        win_left,
        win_top,
        win_width,
        win_height,
        nc.WindowBorderConfig{
            .style = nc.WindowBorderStyle.BorderStyleRegular,
            .color = null,
        },
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(regular_border_window.win);

    const bold_border_window = create_border_window(
        win_left,
        win_top,
        win_width,
        win_height,
        nc.WindowBorderConfig{
            .style = nc.WindowBorderStyle.BorderStyleBold,
            .color = null,
        },
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(bold_border_window.win);

    const rounded_border_window = create_border_window(
        win_left,
        win_top,
        win_width,
        win_height,
        nc.WindowBorderConfig{
            .style = nc.WindowBorderStyle.BorderStyleRounded,
            .color = null,
        },
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(rounded_border_window.win);

    const double_border_window = create_border_window(
        win_left,
        win_top,
        win_width,
        win_height,
        nc.WindowBorderConfig{
            .style = nc.WindowBorderStyle.BorderStyleDouble,
            .color = null,
        },
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(double_border_window.win);

    const custom_ascii_border_window = create_border_window(
        win_left,
        win_top,
        win_width,
        win_height,
        nc.WindowBorderConfig{
            .style = nc.WindowBorderStyle{
                .BorderStyleCustomAscii = nc.WindowBorderChar{
                    .top_left = '*',
                    .top = '#',
                    .top_right = '>',
                    .left = '{',
                    .right = '}',
                    .bottom_left = '[',
                    .bottom = '%',
                    .bottom_right = ']',
                },
            },
            .color = null,
        },
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(custom_ascii_border_window.win);

    const ascii_top_border_color_pair: u16 = 1;
    const ascii_bottom_border_color_pair: u16 = 2;
    const ascii_left_border_color_pair: u16 = 3;
    const ascii_right_border_color_pair: u16 = 4;
    _ = nc.init_pair(ascii_top_border_color_pair, nc.COLOR_RED, nc.COLOR_BLACK);
    _ = nc.init_pair(ascii_bottom_border_color_pair, nc.COLOR_YELLOW, nc.COLOR_BLACK);
    _ = nc.init_pair(ascii_left_border_color_pair, nc.COLOR_GREEN, nc.COLOR_BLACK);
    _ = nc.init_pair(ascii_right_border_color_pair, nc.COLOR_MAGENTA, nc.COLOR_BLACK);
    const ascii_top_attr = nc.color_pair(ascii_top_border_color_pair);
    const ascii_bottom_attr = nc.color_pair(ascii_bottom_border_color_pair);
    const ascii_left_attr = nc.color_pair(ascii_left_border_color_pair);
    const ascii_right_attr = nc.color_pair(ascii_right_border_color_pair);
    const custom_ascii_color_border_window = create_border_window(
        win_left,
        win_top,
        win_width,
        win_height,
        nc.WindowBorderConfig{
            .style = nc.WindowBorderStyle{
                .BorderStyleCustomAscii = nc.WindowBorderChar{
                    .top_left = '*',
                    .top = '#',
                    .top_right = '>',
                    .left = '{',
                    .right = '}',
                    .bottom_left = '[',
                    .bottom = '%',
                    .bottom_right = ']',
                },
            },
            .color = nc.WindowBorderColor{
                .top = ascii_top_attr,
                .bottom = ascii_bottom_attr,
                .left = ascii_left_attr,
                .right = ascii_right_attr,
            },
        },
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(custom_ascii_color_border_window.win);

    const custom_utf8_border_window = create_border_window(
        win_left,
        win_top,
        win_width,
        win_height,
        nc.WindowBorderConfig{
            .style = nc.WindowBorderStyle{
                .BorderStyleCustomUtf8 = nc.WindowBorderWideChar{
                    .top_left = '',
                    .top = '',
                    .top_right = '󰈀',
                    .left = '',
                    .right = '',
                    .bottom_left = '',
                    .bottom = '󰽲',
                    .bottom_right = '󱗾',
                },
            },
            .color = null,
        },
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(custom_utf8_border_window.win);

    const rainbow_window = create_rainbow_window(
        win_left,
        win_top,
        win_width,
        win_height,
    );
    win_top += win_height + y_padding;
    defer _ = nc.delwin(rainbow_window.win);

    _ = nc.wgetch(nc.stdscr);
}

//
//
//
fn create_border_window(
    left: c_int,
    top: c_int,
    width: c_int,
    height: c_int,
    border_config: nc.WindowBorderConfig,
) nc.PopupWindow {
    const popup = nc.create_popup_window(left, top, width, height, false);

    // Draw border
    nc.draw_window_border(popup.win, &border_config);

    // Print content
    // const font_attr = nc.A_ITALIC | nc.A_BOLD | nc.A_UNDERLINE | nc.A_STANDOUT;
    const font_attr: nc.chtype = nc.A_ITALIC | nc.A_BOLD;
    _ = nc.wattr_on(popup.win, font_attr, null);
    _ = nc.mvwprintw(
        popup.win,
        1,
        2,
        "%s",
        @as([*]const u8, @ptrCast(switch (border_config.style) {
            nc.WindowBorderStyle.BorderStyleRegular => "Regular border style",
            nc.WindowBorderStyle.BorderStyleBold => "Bold border style",
            nc.WindowBorderStyle.BorderStyleRounded => "Rounded border style",
            nc.WindowBorderStyle.BorderStyleDouble => "Double border style",
            nc.WindowBorderStyle.BorderStyleCustomAscii => "CustomAscii border style",
            nc.WindowBorderStyle.BorderStyleCustomUtf8 => "CustomUtf8 border style",
        })),
    );
    _ = nc.wattr_off(popup.win, font_attr, null);

    _ = nc.wrefresh(popup.win);
    return popup;
}

//
//
//
fn create_rainbow_window(left: c_int, top: c_int, width: c_int, height: c_int) nc.PopupWindow {
    const popup = nc.create_popup_window(left, top, width, height, false);

    const top_border_color_pair: u16 = 10;
    const bottom_border_color_pair: u16 = 11;
    const left_border_color_pair: u16 = 12;
    const right_border_color_pair: u16 = 13;
    _ = nc.init_pair(top_border_color_pair, nc.COLOR_RED, nc.COLOR_BLACK);
    _ = nc.init_pair(bottom_border_color_pair, nc.COLOR_YELLOW, nc.COLOR_BLACK);
    _ = nc.init_pair(left_border_color_pair, nc.COLOR_GREEN, nc.COLOR_BLACK);
    _ = nc.init_pair(right_border_color_pair, nc.COLOR_MAGENTA, nc.COLOR_BLACK);
    const top_attr = nc.color_pair(top_border_color_pair);
    const bottom_attr = nc.color_pair(bottom_border_color_pair);
    const left_attr = nc.color_pair(left_border_color_pair);
    const right_attr = nc.color_pair(right_border_color_pair);

    const rainbow_border_config = nc.WindowBorderConfig{
        .style = nc.WindowBorderStyle{
            .BorderStyleCustomUtf8 = nc.WindowBorderWideChar{
                .top_left = '',
                .top = '',
                .top_right = '󰈀',
                .left = '',
                .right = '',
                .bottom_left = '',
                .bottom = '󰽲',
                .bottom_right = '󱗾',
            },
        },
        .color = nc.WindowBorderColor{
            .top = top_attr,
            .bottom = bottom_attr,
            .left = left_attr,
            .right = right_attr,
        },
    };

    // Draw border
    nc.draw_window_border(popup.win, &rainbow_border_config);

    // Print content
    // const font_attr = nc.A_ITALIC | nc.A_BOLD | nc.A_UNDERLINE | nc.A_STANDOUT;
    const font_attr = nc.A_ITALIC | nc.A_BOLD;
    _ = nc.wattr_on(popup.win, font_attr | top_attr, null);
    _ = nc.mvwprintw(popup.win, 1, 2, "Custom");
    _ = nc.wattr_off(popup.win, font_attr | top_attr, null);

    _ = nc.wattr_on(popup.win, font_attr | bottom_attr, null);
    _ = nc.wprintw(popup.win, " rainbow");
    _ = nc.wattr_off(popup.win, font_attr | bottom_attr, null);

    _ = nc.wattr_on(popup.win, font_attr | left_attr, null);
    _ = nc.wprintw(popup.win, " border");
    _ = nc.wattr_off(popup.win, font_attr | left_attr, null);

    _ = nc.wattr_on(popup.win, font_attr | right_attr, null);
    _ = nc.wprintw(popup.win, ":)");
    _ = nc.wattr_off(popup.win, font_attr | right_attr, null);

    _ = nc.wrefresh(popup.win);
    return popup;
}
