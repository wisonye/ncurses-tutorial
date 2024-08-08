use types;
use types::c;

export type WINDOW = opaque;
export type chtype = u32;

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
export @symbol("werase") fn werase(win: const nullable *opaque) int;
export @symbol("wclear") fn wclear(win: const nullable *opaque) int;
export @symbol("wrefresh") fn wrefresh(win: const nullable *opaque) int;
export fn refresh() int = {
	return wrefresh(stdscr);
};

export @symbol("wnoutrefresh") fn wnoutrefresh(win: const nullable *opaque) int;
export @symbol("doupdate") fn doupdate() int;

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

