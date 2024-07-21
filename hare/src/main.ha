use fmt;
use nc;
use types::c;

export fn main() void = {
	//
	// Enable UTF8 support
	//
 	const result = nc::setlocale(nc::LC_ALL, c::nulstr("\0"));

	nc::initscr();
	defer nc::endwin();

	nc::mvwprintw(nc::stdscr,
		1, 0,
		c::nulstr(">>> result: %s\0"),
		result,
	);

	const win_rect = nc::get_window_rect(nc::stdscr);
	nc::mvwprintw(nc::stdscr,
		2, 0,
		c::nulstr("Terminal window size: (%d, %d) - (%d, %d)⚡\0"),
		win_rect.left, win_rect.top,
		win_rect.width, win_rect.height,
	);
	nc::mvwprintw(nc::stdscr, 3, 0, c::nulstr("Press any key to exit:)\0"));
	nc::wrefresh(nc::stdscr);

	nc::wgetch(nc::stdscr);
};
