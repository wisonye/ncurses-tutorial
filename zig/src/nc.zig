pub const WINDOW = anyopaque;
pub const chtype = u32;

//
// Locale related
//
pub const LC_CTYPE: c_int = 0;
pub const LC_NUMERIC: c_int = 1;
pub const LC_TIME: c_int = 2;
pub const LC_COLLATE: c_int = 3;
pub const LC_MONETARY: c_int = 4;
pub const LC_MESSAGES: c_int = 5;
pub const LC_ALL: c_int = 6;
pub const LC_PAPER: c_int = 7;
pub const LC_NAME: c_int = 8;
pub const LC_ADDRESS: c_int = 9;
pub const LC_TELEPHONE: c_int = 10;
pub const LC_MEASUREMENT: c_int = 11;
pub const LC_IDENTIFICATION: c_int = 12;
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
pub extern fn wclear(win: ?*WINDOW) c_int;
pub extern fn wrefresh(win: ?*WINDOW) c_int;

pub extern fn wnoutrefresh(win: ?*WINDOW) c_int;
pub extern fn doupdate() c_int;

//
// Print in window related
//
pub extern fn wprintw(
    win: ?*WINDOW,
    fmt: ?[*]const u8,
    ...,
) c_int;

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
pub const CURSOR_INVISIBLE: c_int = 0;
pub const CURSOR_NORMAL: c_int = 1;
pub const CURSOR_VERY_VISIBLE: c_int = 2;

extern fn curs_set(c_int) c_int;
pub fn hide_cursor() c_int {
    return curs_set(CURSOR_INVISIBLE);
}
pub fn show_cursor() c_int {
    return curs_set(CURSOR_NORMAL);
}
pub fn show_cursor_2() c_int {
    return curs_set(CURSOR_VERY_VISIBLE);
}

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
pub const KEY_DEL: c_int = 0x7F; // 127, ^?
pub const KEY_ESCAPE: c_int = 0x1B; // 27, ^[
pub const KEY_TICK: c_int = 0x69; // 96, `
pub const KEY_TILDE: c_int = 0x7E; // 126, ~

pub const KEY_0: c_int = 0x30; // 48, 0
pub const KEY_1: c_int = 0x31; // 49, 1
pub const KEY_2: c_int = 0x32; // 50, 2
pub const KEY_3: c_int = 0x33; // 51, 3
pub const KEY_4: c_int = 0x34; // 52, 4
pub const KEY_5: c_int = 0x35; // 53, 5
pub const KEY_6: c_int = 0x36; // 54, 6
pub const KEY_7: c_int = 0x37; // 55, 7
pub const KEY_8: c_int = 0x38; // 56, 8
pub const KEY_9: c_int = 0x39; // 57, 9
pub const KEY_MINUS: c_int = 0x2D; // 45, -
pub const KEY_EQUAL: c_int = 0x3D; // 61, =

pub const KEY_EXCLAMATION: c_int = 0x21; // 33, !
pub const KEY_AT: c_int = 0x40; // 64, @
pub const KEY_HASH: c_int = 0x23; // 35, #
pub const KEY_DOLLAR: c_int = 0x24; // 36, $
pub const KEY_PERCENT: c_int = 0x25; // 37, %
pub const KEY_UPPER: c_int = 0x5E; // 94, ^
pub const KEY_AMPERSAND: c_int = 0x26; // 38, &
pub const KEY_STAR: c_int = 0x2A; // 42, *
pub const KEY_L_PARENTHESIS: c_int = 0x28; // 40, (
pub const KEY_R_PARENTHESIS: c_int = 0x29; // 41, )
pub const KEY_UNDERSCOPE: c_int = 0x5F; // 95, _
pub const KEY_PLUS: c_int = 0x2B; // 43, +
pub const KEY_L_CURLY_BRACES: c_int = 0x7B; // 123, {
pub const KEY_R_CURLY_BRACES: c_int = 0x7D; // 125, }
pub const KEY_SLASH: c_int = 0x2F; // 47, /
pub const KEY_BACKSLASH: c_int = 0x5C; // 92, '\'
pub const KEY_VERTICAL_BAR: c_int = 0x7C; // 124, |

pub const KEY_COLON: c_int = 0x3A; // 58, :
pub const KEY_SEMICOLON: c_int = 0x3B; // 59, ;
pub const KEY_SINGLE_QUOTE: c_int = 0x27; // 39, '
pub const KEY_DOUBLE_QUOTE: c_int = 0x22; // 34, "
pub const KEY_COMMA: c_int = 0x2C; // 44, ,
pub const KEY_PERIOD: c_int = 0x2E; // 46, .
pub const KEY_L_ARROW_BRACKET: c_int = 0x3C; // 60, <
pub const KEY_R_ARROW_BRACKET: c_int = 0x3E; // 62, >

pub const KEY_D: c_int = 0x64; // 100, d
pub const KEY_E: c_int = 0x65; // 101, e
pub const KEY_F: c_int = 0x66; // 102, f
pub const KEY_P: c_int = 0x70; // 112, p
pub const KEY_S: c_int = 0x73; // 115, s

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
// export fn init_popup_menu(
//     left: usize,
//     top: usize,
//     width: usize,
//     height: usize,
//     items: [*]PopupMenuItem,
//     on_item_click: OnMenuItemClick,
//     with_default_border: bool,
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
//     // 	self.items[index] = items[index];
//     // };
//
//     self.win = newwin(self.height, self.width, self.top, self.left);
//     wrefresh(stdscr);
//
//     // Draw a box with default border to the given window (area)
//     if (with_default_border) {
//         // box(self.win, 0, 0);
//         wrefresh(self.win);
//     }
//
//     return self;
// }
//
// export fn deinit_popup_menu(self: *PopupMenu) void {
//     if (self.win != null) {
//         _ = delwin(self.win);
//         self.win = null;
//     }
//     // free(self.items);
// }
