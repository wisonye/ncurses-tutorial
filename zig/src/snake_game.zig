const std = @import("std");
const nc = @import("nc.zig");
const time = std.time;

// const ENABLE_DEBUG_PRINT: bool = true;
const ENABLE_DEBUG_PRINT: bool = false;

const FOOD_CHAR: nc.chtype = '󱗾';
const SNAKE_HEAD_CHAR: nc.chtype = '';
const SNAKE_BODY_CHAR: nc.chtype = '';

const GAME_TITLE: []const u8 = "[ SNAKE GAME ]";
const GAME_KEYBINDINDS: []const u8 = "E/D/S/F: Direction, P: Pause/Resume, Q: Exit game";
const TOPBAR_HEIGHT: c_int = 5;
const BOARD_HEIGHT: u32 = 30;
const BOARD_WIDTH: u32 = (BOARD_HEIGHT * 2.5);

//
// This is the actual game board
//
const Board = struct {
    left: c_int,
    top: c_int,
    width: c_int,
    height: c_int,
    win: ?*nc.WINDOW,
};

//
// This is only used for drawing the outside the border of the game board,
// so it won't be redrawn whenever the game board changes, it solves the
// refreshing performance issue.
//
const BoardBoundary = struct {
    left: c_int,
    top: c_int,
    width: c_int,
    height: c_int,
    win: ?*nc.WINDOW,
};

const TopBar = struct {
    left: c_int,
    top: c_int,
    width: c_int,
    height: c_int,
    win: ?*nc.WINDOW,
};

//
// Same design purpose with the `BoardBoundary`
//
const TopBarBoundary = struct {
    left: c_int,
    top: c_int,
    width: c_int,
    height: c_int,
    win: ?*nc.WINDOW,
};

const Game = struct {
    level: usize,
    score: usize,
    is_pause: bool,
    is_destroy: bool,
    snake: std.ArrayList(nc.CursorPosition),
    food: std.ArrayList(nc.CursorPosition),
    board: Board,
    board_boundary: BoardBoundary,
    topbar: TopBar,
    // topbar_boundary: TopBarBoundary,
};

pub fn generate_random_u32(max: ?u32) usize {
    const seed: u64 = @intCast(time.microTimestamp());
    var prnd = std.rand.DefaultPrng.init(seed);
    var rand = prnd.random();
    const max_u8 = if (max) |value| value else std.math.maxInt(u32);
    return rand.uintAtMost(u32, max_u8);
}

//
//
//
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
        std.debug.print(">>> Terminal doesn't support colors", .{});
        return;
    }
    _ = nc.start_color();

    //
    // Hide cursor
    //
    _ = nc.hide_cursor();

    for (1..10) |index| {
        _ = nc.mvwprintw(
            nc.stdscr,
            @as(c_int, @intCast(index)),
            0,
            "Random nubmer: %lu",
            generate_random_u32(20),
        );
    }

    _ = nc.wgetch(nc.stdscr);
}
