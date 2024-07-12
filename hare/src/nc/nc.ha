use types;
use types::c;

export type WINDOW = opaque;
export type chtype = u32;

//
// Locale related
//
export def LC_CTYPE: int = 0;
export def LC_NUMERIC: int = 1;
export def LC_TIME: int = 2;
export def LC_COLLATE: int = 3;
export def LC_MONETARY: int = 4;
export def LC_MESSAGES: int = 5;
export def LC_ALL: int = 6;
export def LC_PAPER: int = 7;
export def LC_NAME: int = 8;
export def LC_ADDRESS: int =	9;
export def LC_TELEPHONE: int = 10;
export def LC_MEASUREMENT: int = 11;
export def LC_IDENTIFICATION: int = 12;
export @symbol("setlocale") fn setlocale(category: int, locale: const *c::char) *c::char;

//
// Extern global variable related
//
export let @symbol("curscr") curscr: nullable *WINDOW;
export let @symbol("newscr") newscr: nullable *WINDOW;
export let @symbol("stdscr") stdscr: nullable *WINDOW;

//
// Init, create and delete related
//
export @symbol("initscr") fn initscr() *WINDOW;


//
// Clear and refresh related
//
export @symbol("wclear") fn wclear(win: const nullable *opaque) int;
export @symbol("wrefresh") fn wrefresh(win: const nullable *opaque) int;
export fn refresh() int = {
	return wrefresh(stdscr);
};

//
// Print in window related
//
export @symbol ("wprintw") fn wprintw(
	win: const nullable *WINDOW,
	fmt: const *c::char, ...) int;

export @symbol ("mvwprintw") fn mvwprintw(
	win: const nullable *WINDOW,
	y:int, x: int,
	fmt: const *c::char, ...) int;

