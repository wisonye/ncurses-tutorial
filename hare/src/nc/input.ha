use types::c;

//
// Keys
//

export def KEY_DEL: int             = 0x7F; // 127, ^?
export def KEY_ESCAPE: int          = 0x1B; // 27, ^[
export def KEY_TICK: int            = 0x69; // 96, `
export def KEY_TILDE: int           = 0x7E; // 126, ~

export def KEY_0: int               = 0x30; // 48, 0
export def KEY_1: int               = 0x31; // 49, 1
export def KEY_2: int               = 0x32; // 50, 2
export def KEY_3: int               = 0x33; // 51, 3
export def KEY_4: int               = 0x34; // 52, 4
export def KEY_5: int               = 0x35; // 53, 5
export def KEY_6: int               = 0x36; // 54, 6
export def KEY_7: int               = 0x37; // 55, 7
export def KEY_8: int               = 0x38; // 56, 8
export def KEY_9: int               = 0x39; // 57, 9
export def KEY_MINUS: int           = 0x2D; // 45, -
export def KEY_EQUAL: int           = 0x3D; // 61, =

export def KEY_EXCLAMATION: int     = 0x21; // 33, !
export def KEY_AT: int              = 0x40; // 64, @
export def KEY_HASH: int            = 0x23; // 35, #
export def KEY_DOLLAR: int          = 0x24; // 36, $
export def KEY_PERCENT: int         = 0x25; // 37, %
export def KEY_UPPER: int           = 0x5E; // 94, ^
export def KEY_AMPERSAND: int       = 0x26; // 38, &
export def KEY_STAR: int            = 0x2A; // 42, *
export def KEY_L_PARENTHESIS: int   = 0x28; // 40, (
export def KEY_R_PARENTHESIS: int   = 0x29; // 41, )
export def KEY_UNDERSCOPE: int      = 0x5F; // 95, _
export def KEY_PLUS: int            = 0x2B; // 43, +
export def KEY_L_CURLY_BRACES: int  = 0x7B; // 123, {
export def KEY_R_CURLY_BRACES: int  = 0x7D; // 125, }
export def KEY_SLASH: int           = 0x2F; // 47, /
export def KEY_BACKSLASH: int       = 0x5C; // 92, '\'
export def KEY_VERTICAL_BAR: int    = 0x7C; // 124, |

export def KEY_COLON: int           = 0x3A; // 58, :
export def KEY_SEMICOLON: int       = 0x3B; // 59, ;
export def KEY_SINGLE_QUOTE: int    = 0x27; // 39, '
export def KEY_DOUBLE_QUOTE: int    = 0x22; // 34, "
export def KEY_COMMA: int           = 0x2C; // 44, ,
export def KEY_PERIOD: int          = 0x2E; // 46, .
export def KEY_L_ARROW_BRACKET: int = 0x3C; // 60, <
export def KEY_R_ARROW_BRACKET: int = 0x3E; // 62, >


//
// 0x0D (13)
// This only works after `nc::nonl();`, otherwise, <CR> is `10`, not `13`!!!
//
export def KEY_CR: int = 0x0D; // 13, ^M

export def KEY_TAB: int = 0x09; // 9, ^I
// export def KEY_TAB: int = ('I' & 0x1Fu8): int;

export def KEY_CTRL_A: int = ('A' & 0x1Fu8): int;
export def KEY_CTRL_B: int = ('B' & 0x1Fu8): int;
export def KEY_CTRL_C: int = ('C' & 0x1Fu8): int;
export def KEY_CTRL_D: int = ('D' & 0x1Fu8): int;
export def KEY_CTRL_E: int = ('E' & 0x1Fu8): int;
export def KEY_CTRL_F: int = ('F' & 0x1Fu8): int;
export def KEY_CTRL_G: int = ('G' & 0x1Fu8): int;
export def KEY_CTRL_H: int = ('H' & 0x1Fu8): int;
export def KEY_CTRL_I: int = ('I' & 0x1Fu8): int;
export def KEY_CTRL_J: int = ('J' & 0x1Fu8): int;
export def KEY_CTRL_K: int = ('K' & 0x1Fu8): int;
export def KEY_CTRL_L: int = ('L' & 0x1Fu8): int;
export def KEY_CTRL_M: int = ('M' & 0x1Fu8): int;
export def KEY_CTRL_N: int = ('N' & 0x1Fu8): int;
export def KEY_CTRL_O: int = ('O' & 0x1Fu8): int;
export def KEY_CTRL_P: int = ('P' & 0x1Fu8): int;
export def KEY_CTRL_Q: int = ('Q' & 0x1Fu8): int;
export def KEY_CTRL_R: int = ('R' & 0x1Fu8): int;
export def KEY_CTRL_S: int = ('S' & 0x1Fu8): int;
export def KEY_CTRL_T: int = ('T' & 0x1Fu8): int;
export def KEY_CTRL_U: int = ('U' & 0x1Fu8): int;
export def KEY_CTRL_V: int = ('V' & 0x1Fu8): int;
export def KEY_CTRL_W: int = ('W' & 0x1Fu8): int;
export def KEY_CTRL_X: int = ('X' & 0x1Fu8): int;
export def KEY_CTRL_Y: int = ('Y' & 0x1Fu8): int;
export def KEY_CTRL_Z: int = ('Z' & 0x1Fu8): int;


//
// Input option
//
export @symbol("echo") fn echo() int;
export @symbol("noecho") fn noecho() int;
export @symbol("cbreak") fn cbreak() int;
export @symbol("nocbreak") fn nocbreak() int;
export @symbol("raw") fn raw() int;
export @symbol("noraw") fn noraw() int;
export @symbol("nl") fn nl() int;
export @symbol("nonl") fn nonl() int;
export @symbol("nodelay") fn nodelay(win: const nullable *WINDOW, disabled: bool) int;
export @symbol("notimeout") fn notimeout(win: const nullable *WINDOW, disabled: bool) int;
export @symbol("timeout") fn timeout(delay: int) void;
export @symbol("wtimeout") fn wtimeout(win: const nullable *WINDOW, delay: int) void;

//
// Print key related
//
export @symbol("keyname") fn keyname(key: int) *const c::char;

//
// User input
//
export @symbol("addch") fn addch(ch: const chtype) int;
export @symbol("mvaddch") fn mvaddch(y: int, x: int, ch: const chtype) int;

export @symbol ("wgetch") fn wgetch(win: const nullable *WINDOW) int;
export @symbol("waddch") fn waddch(
	win: const nullable *WINDOW,
	ch: const chtype) int;
export @symbol("mvwaddch") fn mvwaddch(
	win: const nullable *WINDOW,
	y: int,
	x:int ,
	ch: const chtype) int;
export @symbol("waddstr") fn waddstr(win: const nullable *WINDOW, ch: const *c::char) int;

export @symbol("wdelch") fn wdelch(win: const nullable *WINDOW) int;
export @symbol("mvwdelch") fn mvwdelch(
	win: const nullable *WINDOW,
	y: int,
	x: int) int;
