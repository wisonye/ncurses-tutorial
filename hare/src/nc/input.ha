use types::c;

//
// Keys
//
export def KEY_DEL: int = 127;

// This only works after `nc::nonl();`, otherwise, <CR> is `10`, not `13`!!!
export def KEY_CR: int = 13; 

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
export def KEY_CTRL_K: int = ('K' & 0x20u8): int;
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
