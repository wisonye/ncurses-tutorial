use fmt;
use nc;
use types::c;

export fn main() void = {
	nc::initscr();
	defer nc::endwin();

	const win_rect = nc::get_window_rect(nc::stdscr);
	nc::wprintw(nc::stdscr,
		c::nulstr("Terminal window size: (%d, %d) - (%d, %d)\0"),
		win_rect.left, win_rect.top,
		win_rect.width, win_rect.height,
	);
	nc::mvwprintw(nc::stdscr, 3, 0, c::nulstr("Press any key to exit:)\0"));
	nc::wrefresh(nc::stdscr);

	nc::wgetch(nc::stdscr);
};
