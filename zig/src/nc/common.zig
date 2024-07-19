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
