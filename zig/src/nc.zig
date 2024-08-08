// zig fmt: off

const builtin = @import("builtin");

//
pub const WINDOW = anyopaque;
pub const chtype = u32;

//
// Locale related
//

pub const LC_CTYPE: c_int = switch (builtin.os.tag) {
    .linux => 0,
    .freebsd => 2,
    else => unreachable,
};
pub const LC_NUMERIC: c_int = switch (builtin.os.tag) {
    .linux => 1,
    .freebsd => 4,
    else => unreachable,
};
pub const LC_TIME: c_int = switch (builtin.os.tag) {
    .linux => 2,
    .freebsd => 5,
    else => unreachable,
};
pub const LC_COLLATE: c_int = switch (builtin.os.tag) {
    .linux => 3,
    .freebsd => 1,
    else => unreachable,
};
pub const LC_MONETARY: c_int = switch (builtin.os.tag) {
    .linux => 4,
    .freebsd => 3,
    else => unreachable,
};
pub const LC_MESSAGES: c_int = switch (builtin.os.tag) {
    .linux => 5,
    .freebsd => 6,
    else => unreachable,
};
pub const LC_ALL: c_int = switch (builtin.os.tag) {
    .linux => 6,
    .freebsd => 0,
    else => unreachable,
};
pub const LC_PAPER: c_int = switch (builtin.os.tag) {
    .linux => 7,
    else => unreachable,
};
pub const LC_NAME: c_int = switch (builtin.os.tag) {
    .linux => 8,
    else => unreachable,
};
pub const LC_ADDRESS: c_int = switch (builtin.os.tag) {
    .linux => 9,
    else => unreachable,
};
pub const LC_TELEPHONE: c_int = switch (builtin.os.tag) {
    .linux => 10,
    else => unreachable,
};
pub const LC_MEASUREMENT: c_int = switch (builtin.os.tag) {
    .linux => 11,
    else => unreachable,
};
pub const LC_IDENTIFICATION: c_int = switch (builtin.os.tag) {
    .linux => 12,
    else => unreachable,
};

pub extern fn setlocale(
    category: c_int,
    locale: ?[*]const u8,
) ?[*]const u8;

//
// Extern global variable related
//
pub extern const curscr: ?*WINDOW;
pub extern const newscr: ?*WINDOW;
pub extern const stdscr: ?*WINDOW;

//
// Init, create and delete related
//
pub extern fn initscr() *WINDOW;

//
// Clear and refresh related
//
pub extern fn erase() c_int;
pub extern fn werase(win: ?*WINDOW) c_int;
pub extern fn wclear(win: ?*WINDOW) c_int;
pub extern fn wrefresh(win: ?*WINDOW) c_int;

pub extern fn wnoutrefresh(win: ?*WINDOW) c_int;
pub extern fn doupdate() c_int;

//
// Print in window related
//
pub extern fn wprintw( win: ?*WINDOW, fmt: ?[*]const u8, ...) c_int;

pub extern fn mvwprintw(
    win: ?*WINDOW,
    y: c_int,
    x: c_int,
    fmt: ?[*]const u8,
    ...,
) c_int;

// ----------------------------------------------------------------------------
// Cursor
// ----------------------------------------------------------------------------

// Cursor option
pub const CURSOR_INVISIBLE: c_int       = 0;
pub const CURSOR_NORMAL: c_int          = 1;
pub const CURSOR_VERY_VISIBLE: c_int    = 2;

extern fn curs_set(c_int) c_int;
pub fn hide_cursor() c_int { return curs_set(CURSOR_INVISIBLE); }
pub fn show_cursor() c_int { return curs_set(CURSOR_NORMAL); }
pub fn show_cursor_2() c_int { return curs_set(CURSOR_VERY_VISIBLE); }

//
// Get x,y related
//
extern fn getattrs(win: ?*const WINDOW) c_int;
extern fn getcurx(win: ?*const WINDOW) c_int;
extern fn getcury(win: ?*const WINDOW) c_int;
extern fn getbegx(win: ?*const WINDOW) c_int;
extern fn getbegy(win: ?*const WINDOW) c_int;
extern fn getmaxx(win: ?*const WINDOW) c_int;
extern fn getmaxy(win: ?*const WINDOW) c_int;
extern fn getparx(win: ?*const WINDOW) c_int;
extern fn getpary(win: ?*const WINDOW) c_int;

pub const CursorPosition = struct {
    x: c_int,
    y: c_int,
};
pub fn get_cursor_position(win: ?*const WINDOW) CursorPosition {
    return CursorPosition{ .x = getcurx(win), .y = getcury(win) };
}

//
// Move cursor related
//
pub extern fn wmove(win: ?*WINDOW, y: c_int, x: c_int) c_int;
pub fn set_cursor_position(win: ?*WINDOW, pos: *CursorPosition) c_int {
    return wmove(win, pos.y, pos.x);
}

// ----------------------------------------------------------------------------
// Input
// ----------------------------------------------------------------------------

//
// Keys
//
pub const KEY_DEL: c_int                = 0x7F; // 127, ^?
pub const KEY_ESCAPE: c_int             = 0x1B; // 27,  ^[
pub const KEY_TICK: c_int               = 0x69; // 96,  `
pub const KEY_TILDE: c_int              = 0x7E; // 126, ~

pub const KEY_0: c_int                  = 0x30; // 48,  0
pub const KEY_1: c_int                  = 0x31; // 49,  1
pub const KEY_2: c_int                  = 0x32; // 50,  2
pub const KEY_3: c_int                  = 0x33; // 51,  3
pub const KEY_4: c_int                  = 0x34; // 52,  4
pub const KEY_5: c_int                  = 0x35; // 53,  5
pub const KEY_6: c_int                  = 0x36; // 54,  6
pub const KEY_7: c_int                  = 0x37; // 55,  7
pub const KEY_8: c_int                  = 0x38; // 56,  8
pub const KEY_9: c_int                  = 0x39; // 57,  9
pub const KEY_MINUS: c_int              = 0x2D; // 45,  -
pub const KEY_EQUAL: c_int              = 0x3D; // 61,  =

pub const KEY_EXCLAMATION: c_int        = 0x21; // 33,  !
pub const KEY_AT: c_int                 = 0x40; // 64,  @
pub const KEY_HASH: c_int               = 0x23; // 35,  #
pub const KEY_DOLLAR: c_int             = 0x24; // 36,  $
pub const KEY_PERCENT: c_int            = 0x25; // 37,  %
pub const KEY_UPPER: c_int              = 0x5E; // 94,  ^
pub const KEY_AMPERSAND: c_int          = 0x26; // 38,  &
pub const KEY_STAR: c_int               = 0x2A; // 42,  *
pub const KEY_L_PARENTHESIS: c_int      = 0x28; // 40,  (
pub const KEY_R_PARENTHESIS: c_int      = 0x29; // 41,  )
pub const KEY_UNDERSCOPE: c_int         = 0x5F; // 95,  _
pub const KEY_PLUS: c_int               = 0x2B; // 43,  +
pub const KEY_L_CURLY_BRACES: c_int     = 0x7B; // 123, {
pub const KEY_R_CURLY_BRACES: c_int     = 0x7D; // 125, }
pub const KEY_SLASH: c_int              = 0x2F; // 47,  /
pub const KEY_BACKSLASH: c_int          = 0x5C; // 92, '\'
pub const KEY_VERTICAL_BAR: c_int       = 0x7C; // 124, |

pub const KEY_COLON: c_int              = 0x3A; // 58, :
pub const KEY_SEMICOLON: c_int          = 0x3B; // 59, ;
pub const KEY_SINGLE_QUOTE: c_int       = 0x27; // 39, '
pub const KEY_DOUBLE_QUOTE: c_int       = 0x22; // 34, "
pub const KEY_COMMA: c_int              = 0x2C; // 44, ,
pub const KEY_PERIOD: c_int             = 0x2E; // 46, .
pub const KEY_L_ARROW_BRACKET: c_int    = 0x3C; // 60, <
pub const KEY_R_ARROW_BRACKET: c_int    = 0x3E; // 62, >

pub const KEY_D: c_int                  = 0x64; // 100, d
pub const KEY_E: c_int                  = 0x65; // 101, e
pub const KEY_F: c_int                  = 0x66; // 102, f
pub const KEY_P: c_int                  = 0x70; // 112, p
pub const KEY_S: c_int                  = 0x73; // 115, s

//
// 0x0D (13)
// This only works after `nc::nonl();`, otherwise, <CR> is `10`, not `13`!!!
//
pub const KEY_CR: c_int = 0x0D; // 13, ^M

pub const KEY_TAB: c_int = 0x09; // 9, ^I
// pub const KEY_TAB: c_int = ('I' & 0x1Fu8): c_int;

pub const KEY_CTRL_A: c_int = ('A' & 0x1F);
pub const KEY_CTRL_B: c_int = ('B' & 0x1F);
pub const KEY_CTRL_C: c_int = ('C' & 0x1F);
pub const KEY_CTRL_D: c_int = ('D' & 0x1F);
pub const KEY_CTRL_E: c_int = ('E' & 0x1F);
pub const KEY_CTRL_F: c_int = ('F' & 0x1F);
pub const KEY_CTRL_G: c_int = ('G' & 0x1F);
pub const KEY_CTRL_H: c_int = ('H' & 0x1F);
pub const KEY_CTRL_I: c_int = ('I' & 0x1F);
pub const KEY_CTRL_J: c_int = ('J' & 0x1F);
pub const KEY_CTRL_K: c_int = ('K' & 0x1F);
pub const KEY_CTRL_L: c_int = ('L' & 0x1F);
pub const KEY_CTRL_M: c_int = ('M' & 0x1F);
pub const KEY_CTRL_N: c_int = ('N' & 0x1F);
pub const KEY_CTRL_O: c_int = ('O' & 0x1F);
pub const KEY_CTRL_P: c_int = ('P' & 0x1F);
pub const KEY_CTRL_Q: c_int = ('Q' & 0x1F);
pub const KEY_CTRL_R: c_int = ('R' & 0x1F);
pub const KEY_CTRL_S: c_int = ('S' & 0x1F);
pub const KEY_CTRL_T: c_int = ('T' & 0x1F);
pub const KEY_CTRL_U: c_int = ('U' & 0x1F);
pub const KEY_CTRL_V: c_int = ('V' & 0x1F);
pub const KEY_CTRL_W: c_int = ('W' & 0x1F);
pub const KEY_CTRL_X: c_int = ('X' & 0x1F);
pub const KEY_CTRL_Y: c_int = ('Y' & 0x1F);
pub const KEY_CTRL_Z: c_int = ('Z' & 0x1F);

//
// Input option
//
pub extern fn echo() c_int;
pub extern fn noecho() c_int;
pub extern fn cbreak() c_int;
pub extern fn nocbreak() c_int;
pub extern fn raw() c_int;
pub extern fn noraw() c_int;
pub extern fn nl() c_int;
pub extern fn nonl() c_int;
pub extern fn nodelay(win: ?*const WINDOW, disabled: bool) c_int;
pub extern fn notimeout(win: ?*const WINDOW, disabled: bool) c_int;
pub extern fn timeout(delay: c_int) void;
pub extern fn wtimeout(win: ?*const WINDOW, delay: c_int) void;

//
// Print key related
//
pub extern fn keyname(key: c_int) [*:0]const u8;

//
// User input
//
pub extern fn addch(ch: chtype) c_int;
pub extern fn mvaddch(y: c_int, x: c_int, ch: chtype) c_int;

pub extern fn wgetch(win: ?*const WINDOW) c_int;
pub extern fn waddch(win: ?*const WINDOW, ch: chtype) c_int;
pub extern fn mvwaddch(win: ?*const WINDOW, y: c_int, x: c_int, ch: chtype) c_int;
pub extern fn waddstr(win: ?*const WINDOW, ch: ?[*]const u8) c_int;

pub extern fn wdelch(win: ?*const WINDOW) c_int;
pub extern fn mvwdelch(win: ?*const WINDOW, y: c_int, x: c_int) c_int;

// ----------------------------------------------------------------------------
// Window
// ----------------------------------------------------------------------------

//
// Create and destroy
//
pub extern fn newwin(height: c_int, width: c_int, top: c_int, left: c_int) *WINDOW;
pub extern fn derwin(
    origin_win: ?*WINDOW,
    nlines: c_int,
    ncols: c_int,
    begin_y: c_int,
    begin_x: c_int,
) *WINDOW;
pub extern fn delwin(win: ?*WINDOW) c_int;
pub extern fn endwin() c_int;

//
// Size and rect
//
pub const WindowSize = struct {
    width: c_int,
    height: c_int,
};

pub fn get_window_size(win: ?*const WINDOW) WindowSize {
    return WindowSize{
        .width = getmaxx(win),
        .height = getmaxy(win),
    };
}

pub const WindowRect = struct {
    left: c_int,
    top: c_int,
    right: c_int,
    bottom: c_int,
    width: c_int,
    height: c_int,
};

pub fn get_window_rect(win: ?*const WINDOW) WindowRect {
    const left = getbegx(win);
    const top = getbegy(win);
    const width = getmaxx(win);
    const height = getmaxy(win);

    return WindowRect{
        .left = left,
        .top = top,
        .right = left + width,
        .bottom = top + height,
        .width = width,
        .height = height,
    };
}

// ----------------------------------------------------------------------------
// Color and attributes
// ----------------------------------------------------------------------------
pub const NCURSES_ATTR_SHIFT: u32 = 8;

//
// Preconstined attributes
//
pub const A_COLOR: u32          = 65280;
pub const A_ATTRIBUTES: u32     = 4294967040;
pub const A_NORMAL: u32         = 0;
pub const A_STANDOUT: u32       = 65536;
pub const A_UNDERLINE: u32      = 131072;
pub const A_REVERSE: u32        = 262144;
pub const A_BLINK: u32          = 524288;
pub const A_DIM: u32            = 1048576;
pub const A_BOLD: u32           = 2097152;
pub const A_ALTCHARSET: u32     = 4194304;
pub const A_INVIS: u32          = 8388608;
pub const A_PROTECT: u32        = 16777216;
pub const A_HORIZONTAL: u32     = 33554432;
pub const A_LEFT: u32           = 67108864;
pub const A_LOW: u32            = 134217728;
pub const A_RIGHT: u32          = 268435456;
pub const A_TOP: u32            = 536870912;
pub const A_VERTICAL: u32       = 1073741824;
pub const A_ITALIC: u32         = 2147483648;

//
// Preconstined colors
//
pub const COLOR_BLACK: u16      = 0;
pub const COLOR_RED: u16        = 1;
pub const COLOR_GREEN: u16      = 2;
pub const COLOR_YELLOW: u16     = 3;
pub const COLOR_BLUE: u16       = 4;
pub const COLOR_MAGENTA: u16    = 5;
pub const COLOR_CYAN: u16       = 6;
pub const COLOR_WHITE: u16      = 7;

//
// Preconstined types
//
pub const Color = u16;
pub const ColorIndex = u16;
pub const ColorPair = u16;
pub const ColorPairIndex = u16;
pub const VideoAttr = chtype;

//
// Check and enable colors
//
pub extern fn has_colors() bool;
pub extern fn can_change_color() bool;
pub extern fn start_color() c_int;

//
// constine and use color and color pairs (foregroud <-> background)
//
pub extern fn init_color(index: ColorIndex, r: Color, g: Color, b: Color) c_int;

pub extern fn init_pair(
    index: ColorPairIndex,
    foreground_color_index: ColorIndex,
    background_color_index: ColorIndex,
) c_int;

pub fn color_pair(index: ColorPairIndex) VideoAttr {
    return ((index << (0 + NCURSES_ATTR_SHIFT)) & A_COLOR);
}

//
// Enable or disable (video) attributes
//
pub extern fn wattr_on(win: ?*WINDOW, attr: VideoAttr, _: ?*anyopaque) c_int;
pub extern fn wattr_off(win: ?*WINDOW, attr: VideoAttr, _: ?*anyopaque) c_int;

// ----------------------------------------------------------------------------
// Window border
// ----------------------------------------------------------------------------

//
// VT100 symbols are stored in extern `acs_map` array and can be accessed by
// index with an ASCII character.
//
// It constined in the `ncurses` source code
// ./ncurses/llib-lncursesw:chtype acs_map[128];
// ./ncurses/llib-ltinfo:chtype    acs_map[128];
//
pub extern const acs_map: [128]chtype;

//
// `chtype` means a unsigned character, e.g.:
//     'a'~'z', 'A'~ Z', '0'~'9'
//     '*', '?', '>', '<', '=', etc.
//
//     '0' means use the constault charater to fill the border!!!
//
pub extern fn wborder(
    win: ?*WINDOW,
    left: chtype,
    right: chtype,
    top: chtype,
    bottom: chtype,
    top_left_corner: chtype,
    top_right_corner: chtype,
    bottom_left_corner: chtype,
    bottom_right_corner: chtype
) c_int;

pub fn box(win: ?*WINDOW, left_right: chtype, top_bottom: chtype) c_int {
    return wborder(
        win,
        top_bottom,
        top_bottom,
        left_right,
        left_right,
        0,
        0,
        0,
        0,
    );
}

//
// ASCII range border char
//
pub const WindowBorderChar = struct {
    top_left: chtype,
    top: chtype,
    top_right: chtype,
    left: chtype,
    right: chtype,
    bottom_left: chtype,
    bottom: chtype,
    bottom_right: chtype,
};

//
// UTF8 range border char
//
pub const WindowBorderWideChar = struct {
    top_left: chtype,
    top: chtype,
    top_right: chtype,
    left: chtype,
    right: chtype,
    bottom_left: chtype,
    bottom: chtype,
    bottom_right: chtype,
};

pub const WindowBorderColor = struct {
    top: VideoAttr,
    bottom: VideoAttr,
    left: VideoAttr,
    right: VideoAttr,
};

pub const WindowBorderStyle = union(enum) {
    BorderStyleRegular: void,
    BorderStyleBold: void,
    BorderStyleRounded: void,
    BorderStyleDouble: void,
    BorderStyleCustomAscii: WindowBorderChar,
    BorderStyleCustomUtf8: WindowBorderWideChar,
};

pub const WindowBorderConfig = struct {
    style: WindowBorderStyle,
    color: ?WindowBorderColor,
};

const BoldBorderChar = WindowBorderWideChar{
    .top_left = '┏',
    .top = '━',
    .top_right = '┓',
    .left = '┃',
    .right = '┃',
    .bottom_left = '┗',
    .bottom = '━',
    .bottom_right = '┛',
};

const RoundedBorderChar = WindowBorderWideChar{
    .top_left = '╭',
    .top = '─',
    .top_right = '╮',
    .left = '│',
    .right = '│',
    .bottom_left = '╰',
    .bottom = '─',
    .bottom_right = '╯',
};

const DoubleBorderChar = WindowBorderWideChar{
    .top_left = '╔',
    .top = '═',
    .top_right = '╗',
    .left = '║',
    .right = '║',
    .bottom_left = '╚',
    .bottom = '═',
    .bottom_right = '╝',
};

fn draw_window_border_with_char(
    win: ?*WINDOW,
    draw_char: WindowBorderChar,
    draw_color: ?WindowBorderColor,
) void {
    if (draw_color) |color| {
        _ = wborder(
            win,
            @as(chtype, draw_char.left | color.left),
            @as(chtype, draw_char.right | color.right),
            @as(chtype, draw_char.top | color.top),
            @as(chtype, draw_char.bottom | color.bottom),
            @as(chtype, draw_char.top_left | color.top),
            @as(chtype, draw_char.top_right | color.top),
            @as(chtype, draw_char.bottom_left | color.bottom),
            @as(chtype, draw_char.bottom_right | color.bottom),
        );
    } else {
        _ = wborder(
            win,
            draw_char.left,
            draw_char.right,
            draw_char.top,
            draw_char.bottom,
            draw_char.top_left,
            draw_char.top_right,
            draw_char.bottom_left,
            draw_char.bottom_right,
        );
    }
}

fn draw_window_border_with_wide_char(
    win: ?*WINDOW,
    draw_char: WindowBorderWideChar,
    draw_color: ?WindowBorderColor,
) void {
    const rect = get_window_rect(win);

    //
    // Top left
    //
    if (draw_color) |color| {
        _ = wattr_on(win, color.top, null);
        _ = mvwprintw(win, 0, 0, "%lc", draw_char.top_left);
        _ = wattr_off(win, color.top, null);
    } else {
        _ = mvwprintw(win, 0, 0, "%lc", draw_char.top_left);
    }

    //
    // Top
    //
    var draw_len: usize = @as(usize, @intCast(rect.width)) - 1;
    for (1..draw_len) |_| {
        if (draw_color) |color| {
            _ = wattr_on(win, color.top, null);
            _ = wprintw(win, "%lc", draw_char.top);
            _ = wattr_off(win, color.top, null);
        } else {
            _ = wprintw(win, "%lc", draw_char.top);
        }
    }

    //
    // Top right
    //
    if (draw_color) |color| {
        _ = wattr_on(win, color.top, null);
        _ = wprintw(win, "%lc", draw_char.top_right);
        _ = wattr_off(win, color.top, null);
    } else {
        _ = wprintw(win, "%lc", draw_char.top_right);
    }

    //
    // Left & right
    //
    const draw_count: usize = @as(usize, @intCast(rect.height)) - 1;
    for (1..draw_count) |index| {
        if (draw_color) |color| {
            _ = wattr_on(win, color.left, null);
            _ = mvwprintw(win, @as(c_int, @intCast(index)), 0, "%lc", draw_char.left);
            _ = wattr_off(win, color.left, null);

            _ = wattr_on(win, color.right, null);
            _ = mvwprintw(
                win,
                @as(c_int, @intCast(index)),
                rect.width - 1,
                "%lc",
                draw_char.right,
            );
            _ = wattr_off(win, color.right, null);
        } else {
            _ = mvwprintw(win, @as(c_int, @intCast(index)), 0, "%lc", draw_char.left);
            _ = mvwprintw(
                win,
                @as(c_int, @intCast(index)),
                rect.width - 1,
                "%lc",
                draw_char.right,
            );
        }
    }

    //
    // Bottom left
    //
    if (draw_color) |color| {
        _ = wattr_on(win, color.bottom, null);
        _ = mvwprintw(win, rect.height - 1, 0, "%lc", draw_char.bottom_left);
        _ = wattr_off(win, color.bottom, null);
    } else {
        _ = mvwprintw(win, rect.height - 1, 0, "%lc", draw_char.bottom_left);
    }

    //
    // bottom
    //
    //
    draw_len = @as(usize, @intCast(rect.width)) - 1;
    for (1..draw_len) |_| {
        if (draw_color) |color| {
            _ = wattr_on(win, color.bottom, null);
            _ = wprintw(win, "%lc", draw_char.bottom);
            _ = wattr_off(win, color.bottom, null);
        } else {
            _ = wprintw(win, "%lc", draw_char.bottom);
        }
    }

    //
    // Bottom right
    //
    if (draw_color) |color| {
        _ = wattr_on(win, color.bottom, null);
        _ = wprintw(win, "%lc", draw_char.bottom_right);
        _ = wattr_off(win, color.bottom, null);
    } else {
        _ = wprintw(win, "%lc", draw_char.bottom_right);
    }
}

//
//
//
pub fn draw_window_border(win: ?*WINDOW, config: *const WindowBorderConfig) void {
    switch (config.style) {
        .BorderStyleRegular => {
            draw_window_border_with_char(win, WindowBorderChar{
                .left = acs_map[@as(chtype, 'x')],
                .right = acs_map[@as(chtype, 'x')],
                .top = acs_map[@as(chtype, 'q')],
                .bottom = acs_map[@as(chtype, 'q')],
                .top_left = acs_map[@as(chtype, 'l')],
                .top_right = acs_map[@as(chtype, 'k')],
                .bottom_left = acs_map[@as(chtype, 'm')],
                .bottom_right = acs_map[@as(chtype, 'j')],
            }, config.color);
        },
        .BorderStyleBold => {
            draw_window_border_with_wide_char(win, BoldBorderChar, config.color);
        },
        .BorderStyleRounded => {
            draw_window_border_with_wide_char(win, RoundedBorderChar, config.color);
        },
        .BorderStyleDouble => {
            draw_window_border_with_wide_char(win, DoubleBorderChar, config.color);
        },
        .BorderStyleCustomAscii => |draw_char| {
            draw_window_border_with_char(win, draw_char, config.color);
        },
        .BorderStyleCustomUtf8 => |draw_char| {
            draw_window_border_with_wide_char(win, draw_char, config.color);
        },
    }

    _ = wrefresh(win);
}

// ----------------------------------------------------------------------------
// Popup menu
// ----------------------------------------------------------------------------

//
// Popup window
//
pub const PopupWindow = struct {
    win: ?*WINDOW,
    left: c_int,
    top: c_int,
    width: c_int,
    height: c_int,
};

pub fn create_popup_window(
    left: c_int,
    top: c_int,
    width: c_int,
    height: c_int,
    with_default_border: bool,
) PopupWindow {
    var w = PopupWindow{
        .left = left,
        .top = top,
        .width = width,
        .height = height,
        .win = null,
    };
    w.win = newwin(w.height, w.width, w.top, w.left);
    _ = wrefresh(stdscr);

    // Draw a box with default border to the given window (area)
    if (with_default_border) {
        _ = box(w.win, 0, 0);
        _ = wrefresh(w.win);
    }

    return w;
}

// ----------------------------------------------------------------------------
// Popup menu
// ----------------------------------------------------------------------------

// //
// // Popup menu item
// //
// pub const PopupMenuItem = struct {
//     title: []const u8,
// };
//
// pub const OnMenuItemClick = *const fn (*PopupMenuItem) callconv(.C) void;
//
// //
// // Popup menu
// //
// pub const PopupMenu = packed struct {
//     win: ?*WINDOW,
//     left: usize,
//     top: usize,
//     width: usize,
//     height: usize,
//     items: [*]PopupMenuItem,
//     on_item_click: OnMenuItemClick,
// };
//
// pub fn init_popup_menu(
//     left: usize,
//     top: usize,
//     width: usize,
//     height: usize,
//     items: [*]PopupMenuItem,
//     on_item_click: OnMenuItemClick,
//     with_constault_border: bool,
// ) callconv(.C) PopupMenu {
//     var self = PopupMenu{
//         .left = left,
//         .top = top,
//         .width = width,
//         .height = height,
//         // items  = alloc([], item_len),
//         .items = items,
//         .on_item_click = on_item_click,
//         .win = null,
//     };
//
//     // //
//     // // Copy items (allocated on the heap)
//     // //
//     // const item_len = items.len;
//     // for( let index=0z; index < item_len; index +=1) {
//     //     self.items[index] = items[index];
//     // };
//
//     self.win = newwin(self.height, self.width, self.top, self.left);
//     wrefresh(stdscr);
//
//     // Draw a box with constault border to the given window (area)
//     if (with_constault_border) {
//         // box(self.win, 0, 0);
//         wrefresh(self.win);
//     }
//
//     return self;
// }
//
// pub fn deinit_popup_menu(self: *PopupMenu) void {
//     if (self.win != null) {
//         _ = delwin(self.win);
//         self.win = null;
//     }
//     // free(self.items);
// }
